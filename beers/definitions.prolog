% input event declarations
input_event_declaration(turns_on).
input_event_declaration(turns_off).
input_event_declaration(picks).
input_event_declaration(drops).
input_event_declaration(drinks).
input_event_declaration(leaves).

event_def picks_and_drops :=
    picks and drops.

state_def powered_on :=
    turns_on ~> turns_off.

state_def drinking_period :=
    drinks ~> leaves.
