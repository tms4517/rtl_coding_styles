module moduleDeclarationManyParameters
#(parameter int unsigned NUM_CLIENTS = 6
, parameter int unsigned NUM_MODES   = 4

, localparam int unsigned ADDRESS_WIDTH = pa_counter::ADDRESS_WIDTH
, localparam int unsigned DATA_WIDTH    = pa_counter::DATA_WIDTH
)
( input  var logic [ADDRESS_WIDTH-1:0] i_apbAddr
, output var logic [DATA_WIDTH-1:0]    o_apbWriteData
);

endmodule
