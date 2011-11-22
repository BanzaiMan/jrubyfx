require 'jrubyfx'

class WebViewApp
  include JRubyFX

  DEFAULT_URL = "http://jruby.org"

  def start(stage)
    # nodes
    view = build(WebView) {
      set_min_size(500, 400)
      set_pref_size(500, 400)
      engine.load(DEFAULT_URL)
    }
    location = build(TextField, DEFAULT_URL)
    go = build(Button, 'Go', default_button: true)
    # actions
    location.on_action = go.on_action = proc { |event|
      view.engine.load(location.text)
    }
    view.engine.location_property.add_listener(
      listener(ChangeListener, :changed) { |observable, old_value, new_value|
        location.text = new_value
      }
    )
    # layout
    grid = build(GridPane, vgap: 3, hgap: 2) {
      GridPane.set_constraints(location, 0, 0, 1, 1)
      GridPane.set_constraints(go,       1, 0)
      GridPane.set_constraints(view,     0, 1, 1, 1, HPos::LEFT, VPos::CENTER)
      column_constraints <<
        ColumnConstraints.new(100, 460, 500, Priority::ALWAYS, HPos::CENTER, true) <<
        ColumnConstraints.new( 40,  40,  40, Priority::NEVER,  HPos::CENTER, true)
      children << location << go << view
    }
    root = build(Group) {
      children << grid
    }
    with(stage, title: 'WebView', scene: build(Scene, root)).show
  end
end

WebViewApp.start