define [
  "underscore",
  "renderer/properties",
  "./glyph",
], (_, Properties, Glyph) ->

  class SegmentView extends Glyph.View

    _fields: ['x0', 'y0', 'x1', 'y1']
    _properties: ['line']

    _map_data: () ->
      [@sx0, @sy0] = @plot_view.map_to_screen(
        @x0, @glyph_props.x0.units, @y0, @glyph_props.y0.units, @x_range_name, @y_range_name
      )
      [@sx1, @sy1] = @plot_view.map_to_screen(
        @x1, @glyph_props.x1.units, @y1, @glyph_props.y1.units, @x_range_name, @y_range_name
      )

    _render: (ctx, indices) ->
      if @props.line.do_stroke
        for i in indices
          if isNaN(@sx0[i] + @sy0[i] + @sx1[i] + @sy1[i])
            continue

          ctx.beginPath()
          ctx.moveTo(@sx0[i], @sy0[i])
          ctx.lineTo(@sx1[i], @sy1[i])

          @props.line.set_vectorize(ctx, i)
          ctx.stroke()

    draw_legend: (ctx, x0, x1, y0, y1) ->
      @_generic_line_legend(ctx, x0, x1, y0, y1)

  class Segment extends Glyph.Model
    default_view: SegmentView
    type: 'Segment'

    display_defaults: ->
      return _.extend {}, super(), @line_defaults

  class Segments extends Glyph.Collection
    model: Segment

  return {
    Model: Segment
    View: SegmentView
    Collection: new Segments()
  }
