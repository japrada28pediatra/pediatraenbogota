#!/usr/bin/env ruby

require "json"
require "set"
require "uri"

ROOT = File.expand_path("..", __dir__)
EXCLUDED_PREFIXES = %w[PEDIATRIA/ assets/ icons/ ajax/].freeze

def public_html_files
  Dir.glob(File.join(ROOT, "**", "*.html")).filter do |absolute|
    relative = absolute.delete_prefix("#{ROOT}/")
    EXCLUDED_PREFIXES.none? { |prefix| relative.start_with?(prefix) } &&
      !relative.start_with?("google")
  end
end

def canonical_path(relative)
  path = relative.sub(/index\.html\z/, "").sub(/\.html\z/, "/")
  "/#{path}".gsub(%r{/+}, "/")
end

files = public_html_files
known_paths = files.to_h do |absolute|
  relative = absolute.delete_prefix("#{ROOT}/")
  [canonical_path(relative), relative]
end

stats = Hash.new(0)
incoming = Hash.new(0)
unresolved = Hash.new(0)
noncanonical_targets = Hash.new(0)

files.each do |absolute|
  relative = absolute.delete_prefix("#{ROOT}/")
  html = File.binread(absolute).encode("UTF-8", invalid: :replace, undef: :replace)
  source_path = canonical_path(relative)

  stats[:pages] += 1
  stats[:missing_title] += 1 unless html.match?(/<title\b[^>]*>\s*\S.*?<\/title>/mi)
  stats[:missing_description] += 1 unless html.match?(/<meta\s+name="description"\s+content="\S[^"]*"/mi)
  stats[:missing_h1] += 1 unless html.match?(/<h1\b[^>]*>.*?<\/h1>/mi)

  canonical = html[/<link\s+rel="canonical"\s+href="([^"]+)"/mi, 1]
  expected = "https://pediatraenbogota.com#{source_path}"
  stats[:missing_canonical] += 1 unless canonical
  stats[:canonical_mismatch] += 1 if canonical && canonical != expected

  stats[:missing_og_url] += 1 unless html.match?(/<meta\s+property="og:url"\s+content="[^"]+"/mi)
  stats[:schema_blocks] += html.scan(/<script\s+type="application\/ld\+json"/mi).length
  stats[:images_missing_alt] += html.scan(/<img\b[^>]*>/mi).count { |tag| !tag.match?(/\balt\s*=/i) }

  base = html[/<base\s+href="([^"]+)"/mi, 1] || "/"
  html.scan(/<a\b[^>]*\bhref="([^"]+)"/mi).flatten.each do |href|
    next if href.empty? || href.start_with?("#", "mailto:", "tel:", "javascript:", "data:")

    begin
      uri = URI.join("https://pediatraenbogota.com#{base}", href)
    rescue URI::InvalidURIError
      unresolved[href] += 1
      next
    end

    next unless %w[pediatraenbogota.com www.pediatraenbogota.com].include?(uri.host)

    target = uri.path.gsub(%r{/+}, "/")
    normalized = if known_paths.key?(target)
                   target
                 elsif target == "/index" && known_paths.key?("/")
                   "/"
                 elsif known_paths.key?("#{target}/")
                   "#{target}/"
                 elsif target.end_with?(".html") && known_paths.key?(target.sub(/\.html\z/, "/"))
                   target.sub(/\.html\z/, "/")
                 end

    if normalized
      noncanonical_targets[target] += 1 if target != normalized
      incoming[normalized] += 1 unless normalized == source_path
    else
      local_target = target == "/" ? File.join(ROOT, "index.html") : File.join(ROOT, target.delete_prefix("/"))
      unresolved[target] += 1 unless File.exist?(local_target)
    end
  end
end

orphans = known_paths.keys.reject { |path| path == "/" || incoming[path].positive? }

report = {
  generated_at: Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
  pages: stats[:pages],
  metadata: {
    missing_title: stats[:missing_title],
    missing_description: stats[:missing_description],
    missing_h1: stats[:missing_h1],
    missing_canonical: stats[:missing_canonical],
    canonical_mismatch: stats[:canonical_mismatch],
    missing_og_url: stats[:missing_og_url]
  },
  structured_data_blocks: stats[:schema_blocks],
  images_missing_alt: stats[:images_missing_alt],
  internal_links: {
    noncanonical_occurrences: noncanonical_targets.values.sum,
    noncanonical_paths: noncanonical_targets.length,
    unresolved_paths: unresolved.length,
    potential_orphan_pages: orphans.length
  },
  samples: {
    noncanonical_targets: noncanonical_targets.sort_by { |_, count| -count }.first(15).to_h,
    unresolved_targets: unresolved.sort_by { |_, count| -count }.first(15).to_h,
    potential_orphans: orphans.first(25)
  }
}

puts JSON.pretty_generate(report)
