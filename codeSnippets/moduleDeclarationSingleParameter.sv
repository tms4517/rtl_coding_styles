module moduleDeclarationSingleParameter
#(parameter int unsigned DATA_WIDTH = 32)
( input  var logic [DATA_WIDTH-1:0] i_apbReadData
, output var logic [DATA_WIDTH-1:0] o_apbWriteData
);

endmodule
