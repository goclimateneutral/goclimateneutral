# frozen_string_literal: true

json.array! @stripe_events, partial: 'stripe_events/stripe_event', as: :stripe_event
