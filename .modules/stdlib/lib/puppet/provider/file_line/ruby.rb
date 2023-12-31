# frozen_string_literal: true

Puppet::Type.type(:file_line).provide(:ruby) do
  desc <<-DOC
    @summary
      This type allows puppet to manage small config files.

    The implementation matches the full line, including whitespace at the
    beginning and end.  If the line is not contained in the given file, Puppet
    will append the line to the end of the file to ensure the desired state.
    Multiple resources may be declared to manage multiple lines in the same file.
  DOC
  def exists?
    found = false
    lines_count = 0
    lines.each do |line|
      found = line.chomp == resource[:line]
      lines_count += 1 if found
    end
    return found = lines_count.positive? if resource[:match].nil?

    match_count = count_matches(new_match_regex)
    found = if resource[:ensure] == :present
              if match_count.zero?
                if lines_count.zero? && resource[:append_on_no_match].to_s == 'false'
                  true # lies, but gets the job done
                else
                  !(lines_count.zero? && resource[:append_on_no_match].to_s != 'false')
                end
              elsif resource[:replace_all_matches_not_matching_line].to_s == 'true'
                false # maybe lies, but knows there's still work to do
              elsif lines_count.zero?
                resource[:replace].to_s == 'false'
              else
                true
              end
            elsif match_count.zero?
              if lines_count.zero?
                false
              else
                true
              end
            elsif lines_count.zero?
              resource[:match_for_absence].to_s == 'true'
            else
              true
            end
  end

  def create
    return if resource[:replace].to_s != 'true' && count_matches(new_match_regex).positive?

    if resource[:match]
      handle_create_with_match
    elsif resource[:after]
      handle_create_with_after
    else
      handle_append_line
    end
  end

  def destroy
    if resource[:match_for_absence].to_s == 'true' && resource[:match]
      handle_destroy_with_match
    else
      handle_destroy_line
    end
  end

  private

  def lines
    # If this type is ever used with very large files, we should
    #  write this in a different way, using a temp
    #  file; for now assuming that this type is only used on
    #  small-ish config files that can fit into memory without
    #  too much trouble.

    @lines ||= File.readlines(resource[:path], encoding: resource[:encoding])
  rescue TypeError => _e
    # Ruby 1.8 doesn't support open_args
    @lines ||= File.readlines(resource[:path])
  rescue Errno::ENOENT
    raise unless resource.noop?

    @lines ||= []
  end

  def new_after_regex
    resource[:after] ? Regexp.new(resource[:after]) : nil
  end

  def new_match_regex
    resource[:match] ? Regexp.new(resource[:match]) : nil
  end

  def count_matches(regex)
    lines.count do |line|
      if resource[:replace_all_matches_not_matching_line].to_s == 'true'
        line.match(regex) unless line.chomp == resource[:line]
      else
        line.match(regex)
      end
    end
  end

  def handle_create_with_match
    after_regex = new_after_regex
    match_regex = new_match_regex
    match_count = count_matches(new_match_regex)

    raise Puppet::Error, "More than one line in file '#{resource[:path]}' matches pattern '#{resource[:match]}'" if match_count > 1 && resource[:multiple].to_s != 'true'

    File.open(resource[:path], 'w') do |fh|
      lines.each do |line|
        fh.puts(match_regex.match(line) ? resource[:line] : line)
        next unless match_count.zero? && after_regex

        if after_regex.match(line)
          fh.puts(resource[:line])
          match_count += 1 # Increment match_count to indicate that the new line has been inserted.
        end
      end

      fh.puts(resource[:line]) if match_count.zero?
    end
  end

  def handle_create_with_after
    after_regex = new_after_regex
    after_count = count_matches(after_regex)

    if after_count > 1 && resource[:multiple].to_s != 'true'
      raise Puppet::Error, "#{after_count} lines match pattern '#{resource[:after]}' in file '#{resource[:path]}'. One or no line must match the pattern."
    end

    File.open(resource[:path], 'w') do |fh|
      lines.each do |line|
        fh.puts(line)
        fh.puts(resource[:line]) if after_regex.match(line)
      end

      fh.puts(resource[:line]) if after_count.zero?
    end
  end

  def handle_destroy_with_match
    match_regex = new_match_regex
    match_count = count_matches(match_regex)
    raise Puppet::Error, "More than one line in file '#{resource[:path]}' matches pattern '#{resource[:match]}'" if match_count > 1 && resource[:multiple].to_s != 'true'

    local_lines = lines
    File.write(resource[:path], local_lines.reject { |line| match_regex.match(line) }.join)
  end

  def handle_destroy_line
    local_lines = lines
    File.write(resource[:path], local_lines.reject { |line| line.chomp == resource[:line] }.join)
  end

  def handle_append_line
    local_lines = lines
    File.open(resource[:path], 'w') do |fh|
      local_lines.each do |line|
        fh.puts(line)
      end
      fh.puts(resource[:line])
    end
  end
end
