// I prefer this style for long variable assignments.
// Use &{...} for AND, |{...} for OR, ^{...} for XOR.
always_comb
  a = &{longVariableA
      , longVariableB
      , !longVariableC
      };

// Instead of this
always_comb
  a = longVariableA && longVariableB && !longVariableC;
