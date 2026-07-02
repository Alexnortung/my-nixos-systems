{ inputs, ... }@args:

{
  configs = {
    "alex@paper" = import ./configs/alex_at_paper args;
    "alexander@boat" = import ./configs/alexander_at_boat args;
    "alexander@steve" = import ./configs/alexander_at_steve args;
    "alexwork@steve" = import ./configs/alexwork_at_steve args;
    "alexander@spider" = import ./configs/alexander_at_spider args;
  };
}
