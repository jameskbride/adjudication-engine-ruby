module Adjudication
  module Claims
    class ClaimLineItem
      attr_accessor(
        :tooth_code
      )

      attr_reader(
        :status_code,
        :patient_paid,
        :carrier_paid,
        :charged
      )

      def initialize line_item_hash
        @procedure_code = line_item_hash['procedure_code']
        @tooth_code = line_item_hash['tooth_code']
        @charged = line_item_hash['charged']
      end

      def procedure_code
        @procedure_code || ''
      end

      def reject!
        @status_code = 'R'
      end

      def pay!(carrier_paid)
        @status_code = 'P'
        @carrier_paid = carrier_paid
        @patient_paid = charged - carrier_paid
      end

      def ortho?
        procedure_code.start_with? "D8"
      end

      def preventive_and_diagnostic?
        code_digits = procedure_code[1..-1].to_i
        code_digits < 2000
      end

      def inspect
        string = "#<#{self.class.name}:#{self.object_id} "
        fields = [
          :procedure_code,
          :tooth_code,
          :charged,
          :status_code,
          :carrier_paid,
          :patient_paid
        ].map { |s| "#{s}=#{send(s)}" }

        string << fields.join(', ') << ">"
      end
    end
  end
end
