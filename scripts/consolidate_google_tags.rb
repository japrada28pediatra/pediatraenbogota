#!/usr/bin/env ruby

ROOT = File.expand_path("..", __dir__)
EXCLUDED_PREFIXES = %w[PEDIATRIA/ assets/ icons/ ajax/].freeze
LOADER = %r{<script\s+async\s+src="https://www\.googletagmanager\.com/gtag/js\?id=[^"]+"\s*>\s*</script>}mi
INIT_SCRIPT = %r{<script>\s*(?=[^<]*window\.dataLayer)(?=[^<]*function\s+gtag)(?=[^<]*gtag\(["']config["'])[^<]*</script>}mi

files = Dir.glob(File.join(ROOT, "**", "*.html")).filter do |absolute|
  relative = absolute.delete_prefix("#{ROOT}/")
  EXCLUDED_PREFIXES.none? { |prefix| relative.start_with?(prefix) } &&
    !relative.start_with?("google")
end

updated = 0

files.each do |file|
  original = File.binread(file)
  next unless original.scan(LOADER).length > 1

  config_ids = original.scan(/gtag\(["']config["'],\s*["'](AW-[^"']+|G-[^"']+)["']/).flatten.uniq
  next if config_ids.empty?

  html = original.sub(LOADER, "__DIRECT_GTAG_BLOCK__")
  html.gsub!(LOADER, "")
  html.gsub!(INIT_SCRIPT, "")

  config_lines = config_ids.map { |id| "  gtag('config', '#{id}');" }.join("\n")
  block = <<~HTML.chomp
    <!-- Google tag (gtag.js) -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-D0Z8XKBJ34"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
    #{config_lines}
    </script>
  HTML

  html.sub!("__DIRECT_GTAG_BLOCK__", block)
  next if html == original

  File.binwrite(file, html)
  updated += 1
end

puts "updated_files=#{updated}"
