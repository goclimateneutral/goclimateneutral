# frozen_string_literal: true

module I18nHelpers
  def with_translations(locale, translations)
    original_backend = I18n.backend
    I18n.backend = I18n::Backend::Simple.new
    I18n.t('initialize') # Force loading so stored translations after take presedence
    I18n.backend.store_translations(locale, translations)
    yield
    I18n.backend = original_backend
  end
end
