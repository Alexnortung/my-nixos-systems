{ inputs, ... }@args:

{
  configs = {
    # "alexander@boat" = import ./configs/alexander_at_boat inputs;
    "alexander@steve" = import ./configs/alexander_at_steve args;
  };
}
