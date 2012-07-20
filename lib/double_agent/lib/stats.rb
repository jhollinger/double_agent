module DoubleAgent
  module Stats
    # A generic class for DoubleAgent::Stats result sets
    class ResultSet
      include Enumerable
      # The options Hash passed in the constructor
      attr_reader :options
      # The attribute(s) that are being statted, passed in the constructor
      attr_reader :attributes
      # The original array of DoubleAgent::Resource objects from which the stats were generated
      attr_reader :resources

      # Accepts an array of objects, and an unlimited number of method symbols (which sould be methods in the objects).
      # Optionally accepts an options hash as a last argument.
      #
      # Implements Enumerable, so the results can be accessed by any of those methods, including each and to_a.
      def initialize(resources, *args)
        @options = args.last.is_a?(Hash) ? args.pop : {}
        @attributes = args
        @resources = resources
        @results = []
      end

      # Implements the "each" method required by Enumerable.
      def each(&block)
        calculate!
        @results.each &block
      end

      # Tests equality between this and another set
      def ==(other)
        calculate!
        @results == other.to_a
      end

      # Tests equality between this and another set
      def ===(other)
        calculate!
        @results === other.to_a
      end

      private

      # Run the calculation if it hasn't already been
      def deferred_calculate!
        calculate! if @results.empty?
      end
    end

    # Calculates and contains the counts of each attr (or attr group).
    # 
    # Don't create instance manually. Instead, use the DoubleAgent::Stats.counts method, which will return
    # a properly instantiated object.
    class Count < ResultSet
      private

      # Calculates the counts
      def calculate!
        # Count the occurrence of each
        results = resources.inject({}) do |res, resource|
          attrs = attributes.map { |attr| resource.send attr }
          res[attrs] ||= 0
          res[attrs] += 1
          res
        end.to_a
        results.each(&:flatten!)
        # Sort in ascending order
        results.sort! { |a,b| b.last <=> a.last }
        @results = results
      end
    end

    # Calculates and contains the percent counts of each attr (or attr group).
    # 
    # If you passed an options Hash containing :threshold to the constructor, 
    # any results falling below it will be excluded.
    # 
    # Don't create instance manually. Instead, use the DoubleAgent::Stats.percentages method, which will return
    # a properly instantiated object.
    class Percentage < Count
      private

      # Perform the calculations
      def calculate!
        super
        calculate_percentages!
      end

      # Calculates the percentages
      def calculate_percentages!
        total = resources.size.to_f
        # Add in the percent
        @results.map! do |*args, count|
          percent = ((count * 100) / total).round(2)
          [*args, percent, count]
        end
        # Drop results that are too small
        if options.has_key? :threshold
          @results.reject! { |result| result[-2] < options[:threshold] }
        end
      end
    end
  end
end
