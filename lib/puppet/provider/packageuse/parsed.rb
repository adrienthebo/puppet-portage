require 'puppet/provider/parsedfile'
 
Puppet::Type.type(:packageuse).provide(:parsed,
    :parent => Puppet::Provider::ParsedFile,
    :default_target => "/etc/portage/package.use",
    :filetype => :flat
) do

    desc "The packageuse provider that uses the ParsedFile class"
 
    text_line :comment, :match => /^#/;
    text_line :blank, :match => /^\s*$/;
 
    record_line :parsed, :fields => %w{package use_flags},
        :joiner => ' ',
        :rts    => true do |line|
        hash = {}
        if line.sub!(/^(\S+)\s+(.*)\s*$/, '')
            hash[:name] = $1
            use_flags = $2

            unless use_flags == ""
                hash[:use_flags] = use_flags.split(/\s+/)
            end
        else
            raise Puppet::Error, "Could not match '%s'" % line
        end
 
        if hash[:use_flags] == ""
            hash.delete(:use_flags)
        end
 
        return hash
    end

    def self.to_line(hash)
        return super unless hash[:record_type] == :parsed
        unless hash[:name] and hash[:name] != :absent
            raise ArgumentError, "package is a required attribute for packageuse"
        end

        str = hash[:name]

        if hash.include? :use_flags
            if hash[:use_flags].is_a? Array
                str += " %s" % hash[:use_flags].join(" ")
            else
                str += " %s" % hash[:use_flags]
            end
        end

        str
    end
    
end
