router
#(.GRID_WIDTH         (GRID_WIDTH)
, .PACKET_WIDTH       (PACKET_WIDTH)
, .FIFO_ADDRESS_WIDTH (FIFO_ADDRESS_WIDTH)
, .ROUTER_ROW         (i)
, .ROUTER_COL         (j)
) u_router
( .i_clk    (i_clk)
, .i_arst_n (i_arst_n)

, .i_ni      (i_niToRouter[i][j])
, .i_niValid (i_niToRouterValid[i][j])
, .o_niReady (o_niToRouterReady[i][j])

, .o_ni      (o_routerToNi[i][j])
, .o_niValid (o_routerToNiValid[i][j])
, .i_niReady (i_routerToNiReady[i][j])
);

