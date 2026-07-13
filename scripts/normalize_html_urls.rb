#!/usr/bin/env ruby

require "uri"

ROOT = File.expand_path("..", __dir__)
DOMAIN = "https://pediatraenbogota.com"
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

updated_files = 0
canonical_updates = 0
og_updates = 0
og_insertions = 0
link_updates = 0

files.each do |absolute|
  relative = absolute.delete_prefix("#{ROOT}/")
  original = File.binread(absolute)
  html = original.dup
  path = canonical_path(relative)
  expected_url = "#{DOMAIN}#{path}"

  html.sub!(/(<link\s+rel="canonical"\s+href=")[^"]+("[^>]*>)/mi) do
    canonical_updates += 1 if Regexp.last_match(0) != "#{Regexp.last_match(1)}#{expected_url}#{Regexp.last_match(2)}"
    "#{Regexp.last_match(1)}#{expected_url}#{Regexp.last_match(2)}"
  end

  if html.match?(/<meta\s+property="og:url"\s+content="[^"]*"[^>]*>/mi)
    html.sub!(/(<meta\s+property="og:url"\s+content=")[^"]*("[^>]*>)/mi) do
      replacement = "#{Regexp.last_match(1)}#{expected_url}#{Regexp.last_match(2)}"
      og_updates += 1 if Regexp.last_match(0) != replacement
      replacement
    end
  else
    canonical_tag = html[/<link\s+rel="canonical"\s+href="[^"]+"[^>]*>/mi]
    if canonical_tag
      html.sub!(canonical_tag, "#{canonical_tag}\n  <meta property=\"og:url\" content=\"#{expected_url}\">")
      og_insertions += 1
    end
  end

  base = html[/<base\s+href="([^"]+)"/mi, 1] || "/"
  html.gsub!(/(<a\b[^>]*\bhref=")([^"]+)(")/mi) do
    prefix = Regexp.last_match(1)
    href = Regexp.last_match(2)
    suffix = Regexp.last_match(3)
    replacement = href

    unless href.empty? || href.start_with?("#", "mailto:", "tel:", "javascript:", "data:")
      begin
        uri = URI.join("#{DOMAIN}#{base}", href)
        if %w[pediatraenbogota.com www.pediatraenbogota.com].include?(uri.host)
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

          if normalized && normalized != target
            replacement = normalized
            replacement += "?#{uri.query}" if uri.query
            replacement += "##{uri.fragment}" if uri.fragment
            link_updates += 1
          end
        end
      rescue URI::InvalidURIError
        # The audit script reports invalid links; this normalizer leaves them unchanged.
      end
    end

    "#{prefix}#{replacement}#{suffix}"
  end

  next if html == original

  File.binwrite(absolute, html)
  updated_files += 1
end

puts({
  updated_files: updated_files,
  canonical_updates: canonical_updates,
  og_updates: og_updates,
  og_insertions: og_insertions,
  link_updates: link_updates
}.map { |key, value| "#{key}=#{value}" }.join(" "))
