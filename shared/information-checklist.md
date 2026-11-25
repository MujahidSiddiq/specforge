# Information a design specification needs

Used by both intake guides to find what the inputs do not say. For each
item, the analysis report records whether the inputs give it (with the
source), give it only partly, or do not give it. Items that are missing
become questions.

## Purpose and context

- [ ] What the design is for, in one or two sentences.
- [ ] Where it sits in the surrounding system; who drives its inputs and
      uses its outputs.
- [ ] Related documents (detailed or parent specification), if any.

## Structure

- [ ] The top-level module name.
- [ ] The major blocks and, for each, its responsibility.
- [ ] The hierarchy down to the leaf modules.
- [ ] The main connections between the blocks, grouped by function.
- [ ] Configuration parameters: meaning, default, allowed range or
      constraints.

## Interfaces

- [ ] Every external signal or interface, grouped by function.
- [ ] For each group: direction, purpose, and the condition under which it
      is valid.
- [ ] Clock and reset: number of clocks; reset polarity and whether it is
      synchronous or asynchronous.
- [ ] Protocol rules the environment must follow (for example: an input is
      never high while a status output says "full").

## Behaviour

- [ ] Every operation the design performs: trigger, effect, timing at the
      interfaces (same cycle, next cycle, latency).
- [ ] The outputs in each condition, including when they are not valid.
- [ ] Boundary cases of each operation: empty, full, wrap-around, no-op.
- [ ] Recovery or error handling, if the design has any.

## Exceptional conditions

- [ ] Reset: what is reset, to what; what is not reset.
- [ ] Flush or cancel: what is discarded and what is kept.
- [ ] Every combination of simultaneous operations the interfaces allow:
      outcome or priority, or a guarantee that it does not occur.

## Constraints and limitations

- [ ] Assumptions on the environment.
- [ ] Known limitations (behaviour that is by design not handled or not
      detected).
- [ ] Open points already known to the user.

## Document wishes

- [ ] Terms the user prefers or forbids.
- [ ] Figures the user wants (and how they should look).
- [ ] Anything that must or must not be in the document.
