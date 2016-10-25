module Yacs
  module Catalog
    class Updater
      class << self

      def quick_update
        catalog.quick.each do |section|
          update Section.find_by(quick_section_field => section.send quick_section_field), section
        end
      end

      def tree_update
        catalog.tree.each do |department|
          existing_department = Department.find_by department_field => department.send department_field
          diff_set existing_department.courses, course_field, department.courses
          department.courses.each do |course|
            existing_course = existing_department.courses.find_by course_field => course.send course_field
            diff_set existing_course.sections, section_field, course.sections
          end
        end
      end

      private

      def diff_set scope, field, records
        records = map records
        scope.find_each do |record|
          record.destroy unless records[record.send field].present?
        end

        records.each do |new_record|
          old_record = scope.find_by field => new_record.send field
          old_record.present? ? update old_record, new_record : new_record.save!
        end
      end

      def update old_record, new_record
        old_record.update_attributes new_record.attributes.compact
      end

      def map records, field
        mapped_records = {}
        records.each do |record|
          mapped_records[record.send field] = record
        end
        mapped_records
      end

      def departmet_field;     :code;   end;
      def course_field;        :number; end;
      def section_field;       :name;   end;
      def quick_section_field; :crn;    end;
    end
  end
end
