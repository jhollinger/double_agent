module DoubleAgent
  module Parsers
    # objects can then be used to grab further info from user agent strings, though
    # that is not currently happening.
    class OS
      attr_reader :os, :sym, :family_sym

      # Instantiate a new OSParser using an "OS family" element from OS_DATA
      def initialize(attrs={})
        @sym = attrs[:sym]
        @family_sym = attrs[:family_sym] || @sym
        @os = attrs[:name]
      end

      # Returns the OSParser for this OSParser object's Family. E.g. the Ubuntu
      # OSParser would return the GNU/Linux OSerParser. For OSes that are their own
      # family (e.g. OS X) it will end up returning itself.
      def family
        OSES[@family_sym]
      end
    end
  end
end
