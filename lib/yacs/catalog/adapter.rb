module Yacs
  module Catalog
    class Adapter
      class << self

      def tree
        raise "ERROR: Implementation Required"
      end

      def quick
        raise "ERROR: Implementation Required"
      end
    end
  end
end
