{ inputs, ... }:

{
  configs = {
    "alexander@boat" = import ./configs/alexander_at_boat inputs;
  };
}
