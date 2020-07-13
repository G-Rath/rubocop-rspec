# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Checks if there is an empty line after subject block.
      #
      # @example
      #   # bad
      #   subject(:obj) { described_class }
      #   let(:foo) { bar }
      #
      #   # good
      #   subject(:obj) { described_class }
      #
      #   let(:foo) { bar }
      class EmptyLineAfterSubject < Cop
        extend AutoCorrector
        include RuboCop::RSpec::BlankLineSeparation

        MSG = 'Add an empty line after `%<subject>s`.'

        def on_block(node)
          return unless subject?(node) && !in_spec_block?(node)
          return if last_child?(node)

          missing_separating_line(node) do |location|
            msg = format(MSG, subject: node.method_name)
            add_offense(location, message: msg) do |corrector|
              corrector.insert_after(location.end, "\n")
            end
          end
        end

        private

        def in_spec_block?(node)
          node.each_ancestor(:block).any? do |ancestor|
            Examples::ALL.include?(ancestor.method_name)
          end
        end
      end
    end
  end
end
