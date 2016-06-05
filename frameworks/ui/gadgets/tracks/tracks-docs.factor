USING: ui.gadgets.packs help.markup help.syntax ui.gadgets
arrays kernel quotations classes.tuple ;
in: ui.gadgets.tracks

ARTICLE: "ui-track-layout" "Track layouts"
"Track gadgets are like " { $link "ui-pack-layout" } " except each child is resized to a fixed multiple of the track's dimension."
{ $subsections track }
"Creating empty tracks:"
{ $subsections <track> }
"Adding children:"
{ $subsections track-add } ;

HELP: <track>
{ $values { "orientation" "an orientation specifier" } { "track" "a new " { $link track } } }
{ $description "Creates a new track which lays out children along the given orientation, either " { $link horizontal } " or " { $link vertical } "." } ;

HELP: new-track
{ $values
  { "orientation" "an orientation specifier" }
  { "class" "a gadget class" }
  { "track" gadget }
}
{ $description "Creates a new container gadget of the specified class and sets its children lay out to either " { $link horizontal } " or " { $link vertical } "." } ;

HELP: track
{ $class-description "A track is like a " { $link pack } " except each child is resized to a fixed multiple of the track's dimension in the direction of " { $snippet "orientation" } ". Tracks are created by calling " { $link <track> } "." } ;

HELP: track-add
{ $values { "track" track } { "gadget" gadget } { "constraint" "a number between 0 and 1, or " { $link f } } }
{ $description "Adds a new child to a track. If the constraint is " { $link f } ", the child always occupies its preferred size. Otherwise, the constrant is a fraction of the total size which is allocated for the child." } ;

about: "ui-track-layout"
