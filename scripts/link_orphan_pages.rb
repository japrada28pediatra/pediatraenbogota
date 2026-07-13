#!/usr/bin/env ruby

require "cgi"
require "uri"

ROOT = File.expand_path("..", __dir__)
DOMAIN = "https://pediatraenbogota.com"
EXCLUDED_PREFIXES = %w[PEDIATRIA/ assets/ icons/ ajax/].freeze
MARKER = "<!-- SEO: páginas adicionales de la categoría -->"

files = Dir.glob(File.join(ROOT, "**", "*.html")).filter do |absolute|
  relative = absolute.delete_prefix("#{ROOT}/")
  EXCLUDED_PREFIXES.none? { |prefix| relative.start_with?(prefix) } &&
    !relative.start_with?("google")
end

def canonical_path(relative)
  path = relative.sub(/index\.html\z/, "").sub(/\.html\z/, "/")
  "/#{path}".gsub(%r{/+}, "/")
end

paths = files.to_h do |absolute|
  relative = absolute.delete_prefix("#{ROOT}/")
  [canonical_path(relative), absolute]
end

incoming = Hash.new(0)

files.each do |absolute|
  relative = absolute.delete_prefix("#{ROOT}/")
  source = canonical_path(relative)
  html = File.binread(absolute).encode("UTF-8", invalid: :replace, undef: :replace)
  base = html[/<base\s+href="([^"]+)"/mi, 1] || "/"

  html.scan(/<a\b[^>]*\bhref="([^"]+)"/mi).flatten.each do |href|
    next if href.empty? || href.start_with?("#", "mailto:", "tel:", "javascript:", "data:")

    begin
      uri = URI.join("#{DOMAIN}#{base}", href)
    rescue URI::InvalidURIError
      next
    end
    next unless %w[pediatraenbogota.com www.pediatraenbogota.com].include?(uri.host)

    target = uri.path.gsub(%r{/+}, "/")
    target = "#{target}/" if !paths.key?(target) && paths.key?("#{target}/")
    incoming[target] += 1 if paths.key?(target) && target != source
  end
end

orphans = paths.keys.reject { |path| path == "/" || incoming[path].positive? }
category_orphans = orphans.group_by { |path| path.split("/").reject(&:empty?).first }
category_orphans.select! do |category, category_paths|
  category_paths.all? { |path| path.split("/").reject(&:empty?).length == 2 } &&
    File.file?(File.join(ROOT, category, "index.html"))
end

updated = 0
linked = 0
skipped = []

category_orphans.sort.each do |category, category_paths|
  index_file = File.join(ROOT, category, "index.html")
  html = File.binread(index_file)
  next if html.include?(MARKER)

  links = category_paths.sort.map do |path|
    target_file = paths.fetch(path)
    target_html = File.binread(target_file).encode("UTF-8", invalid: :replace, undef: :replace)
    heading = target_html[/<h1\b[^>]*>(.*?)<\/h1>/mi, 1]
    heading = heading&.gsub(/<[^>]+>/, " ")&.gsub(/\s+/, " ")&.strip
    heading = File.basename(path.sub(%r{/\z}, "")).tr("-", " ") if heading.nil? || heading.empty?
    linked += 1
    "<a href=\"#{path}\">#{CGI.escapeHTML(heading)}</a>"
  end.join

  hub_h1 = html.encode("UTF-8", invalid: :replace, undef: :replace)[/<h1\b[^>]*>(.*?)<\/h1>/mi, 1]
  hub_h1 = hub_h1&.gsub(/<[^>]+>/, " ")&.gsub(/\s+/, " ")&.strip
  hub_h1 = category.tr("-", " ") if hub_h1.nil? || hub_h1.empty?

  section = <<~HTML
    #{MARKER}
    <section class="section section-soft" aria-labelledby="temas-adicionales">
      <div class="container">
        <div class="section-head">
          <span class="eyebrow">Más información útil</span>
          <h2 id="temas-adicionales">Más temas sobre #{CGI.escapeHTML(hub_h1)}</h2>
          <p>Consulta contenidos relacionados para encontrar orientación según la edad, el motivo de consulta y la modalidad de atención.</p>
        </div>
        <div class="related-inline">#{links}</div>
      </div>
    </section>
  HTML

  if html.sub!(%r{</main>}i, "#{section}</main>")
    File.binwrite(index_file, html)
    updated += 1
  else
    skipped << index_file.delete_prefix("#{ROOT}/")
  end
end

puts "updated_hubs=#{updated} linked_orphans=#{linked} skipped=#{skipped.length}"
skipped.each { |file| puts "skipped=#{file}" }
