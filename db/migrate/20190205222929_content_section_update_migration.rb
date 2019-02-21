class ContentSectionUpdateMigration < ActiveRecord::Migration[5.2]
	def change
		rename_column	:pulitzer_content_sections, :title, :header
		rename_column	:pulitzer_content_sections, :css_classes, :section_classes
		rename_column	:pulitzer_content_sections, :css_style, :section_style
		add_column		:pulitzer_content_sections, :header_tag, :string, default: 'h2'
		add_column		:pulitzer_content_sections, :header_classes, :string
		add_column		:pulitzer_content_sections, :header_style, :string
		add_column		:pulitzer_content_sections, :content_classes, :string
		add_column		:pulitzer_content_sections, :content_style, :string
	end
end
