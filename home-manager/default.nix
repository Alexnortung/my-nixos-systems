{ inputs, ... }@args:

{
  configs = {
    "alexander@boat" = import ./configs/alexander_at_boat args;
    "alexander@steve" = import ./configs/alexander_at_steve args;
    "alexander@spider" = import ./configs/alexander_at_spider args;
  };
}
