# frozen_string_literal: true

module ReactComponentHelper
  def react_component(component_name, **props)
    content_tag(
      :div,
      nil,
      {
        'data-controller' => 'react-component',
        'data-react-component' => component_name,
        'data-react-props' => JSON.generate(props)
      }
    )
  end
end
