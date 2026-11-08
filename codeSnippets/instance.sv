router
#(.GRID_WIDTH         (GRID_WIDTH)
, .PACKET_WIDTH       (PACKET_WIDTH)
, .FIFO_ADDRESS_WIDTH (FIFO_ADDRESS_WIDTH)
, .ROUTER_ROW         (row)
, .ROUTER_COL         (col)
) u_router
( .i_clk    (i_clk)
, .i_arst_n (i_arst_n)

, .i_ni      (i_niToRouter[row][col])
, .i_niValid (i_niToRouterValid[row][col])
, .o_niReady (o_niToRouterReady[row][col])

, .o_ni      (o_routerToNi[row][col])
, .o_niValid (o_routerToNiValid[row][col])
, .i_niReady (i_routerToNiReady[row][col])
);

