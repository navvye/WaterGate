BeginPackage["HexagonalCellularAutomata`"]

(* Usage messages for exported functions *)
HexagonalGraphGen::usage = "YourFunction[x] computes something using x.";

Begin["`Private`"] (* Begin Private Context *)

vertexData=Nothing;

NearestHexPoints[point_, coordinates_] := 
  Map[UndirectedEdge[point, #] &, Nearest[coordinates, point, {7, 2}]][[2 ;;]]

End[]

HexagonalGraphGen[n_, m_] := Module[
  {coordinates, edges},
  coordinates = Flatten[
    Table[
      {i*Sqrt[3], j},
      {i, 1, n},
      {j, Mod[i, 2], (m - 1)*2, 2}
    ],
    1
  ];
  edges = DeleteDuplicates[
    Sort /@ Flatten[Map[NearestHexPoints[#, coordinates] &, coordinates], 1]
  ];
  Graph[coordinates, edges, VertexCoordinates -> coordinates]
]

InitializeCellularAutomata[geoPosition_GeoPosition, geoRange_, nodeDensity_, waterLevelFunction_] := Module[
  {graph, graphLength, coefficient, geoCoordinatesOfEachNode, heights},
  graphLength = Sqrt[nodeDensity]*geoRange;
  graph = HexagonalGraphGen[graphLength, graphLength];
  coefficient = geoRange/VertexList[graph][[-1]][[1]];
  geoCoordinatesOfEachNode = (geoPosition[[1]] - {geoRange, geoRange}/2 + #*coefficient) & /@ VertexList[graph];
  heights = QuantityMagnitude@GeoElevationData[GeoPosition[geoCoordinatesOfEachNode]];
  vertexData = AssociationThread[
    VertexList[graph],
    MapIndexed[
      <|
        "groundHeight" -> heights[[#2]][[1]],
        "waterLevel" -> If[NumberQ[waterLevelFunction], waterLevelFunction, waterLevelFunction[#1]],
        "drainAmount" -> {}
      |> &,
      VertexList[graph]
    ]
  ];
  graph
]

InitVertexData[graph_Graph, groundHeightFunction_, waterLevelFunction_] := (
  vertexData = AssociationThread[
    VertexList[graph],
    <|
      "groundHeight" -> groundHeightFunction[#],
      "waterLevel" -> waterLevelFunction[#],
      "drainAmount" -> {}
    |> & /@ VertexList[graph]
  ]
)

VisualizeWaterData[graph_Graph, vertexData_] := SimpleGraph[
  graph,
  VertexSize -> ((# -> vertexData[#]["groundHeight"] + vertexData[#]["waterLevel"]) &) /@ VertexList[graph]
]

VisualizeWaterData[graph_Graph, vertexData_, waterLevelSizeWeight_, groundLevelSizeWeight_] := SimpleGraph[
  graph,
  VertexSize -> ((# -> (vertexData[#]["groundHeight"]*groundLevelSizeWeight + vertexData[#]["waterLevel"]*waterLevelSizeWeight)) &) /@ VertexList[graph]
]

VisualizeWaterData3D[graph_Graph, vertexData_] := ListPointPlot3D[
  {
    Join[#, {vertexData[#]["groundHeight"]}] & /@ VertexList[graph],
    Join[#, {vertexData[#]["groundHeight"] + vertexData[#]["waterLevel"]}] & /@ VertexList[graph]
  }
]

VisualizeWaterData3D[graph_Graph, vertexData_, waterLevelScale_, groundHeightScale_] := ListPointPlot3D[
  {
    Join[#, {vertexData[#]["groundHeight"]*groundHeightScale}] & /@ VertexList[graph],
    Join[#, {vertexData[#]["groundHeight"]*groundHeightScale + vertexData[#]["waterLevel"]*waterLevelScale}] & /@ VertexList[graph]
  }
]

CalculateNeighborhoodWaterLevels[graph_Graph, vertex_List, flowRate_] := Module[
  {neighborhood, W, H, k = 0, heights, assoc},
  (*sort neighborhood by ground height*)
  neighborhood = SortBy[Neighbors[graph, vertex], (vertexData[#]["groundHeight"]) &];
  heights = (vertexData[#]["groundHeight"]) & /@ neighborhood;
  W = Total[vertexData[#]["waterLevel"] & /@ neighborhood]; (*calculate the total "volume" of water*)
  Table[
    If[
      Sum[heights[[k1]] - heights[[ihi2]], {ihi2, 1, k1}] <= W,
      k = k1;
      Return["Exit", Table]
    ],
    {k1, Length[neighborhood], 1, -1}
  ]; (*calculate k *)
  H = (W + Sum[heights[[ihi]], {ihi, 1, k}])/k;
  AppendTo[vertexData[#]["drainAmount"], vertexData[#]["waterLevel"] + (H - (vertexData[#]["groundHeight"] + vertexData[#]["waterLevel"])) * (1 - flowRate)] & /@ neighborhood[[;; k]];
  AppendTo[vertexData[#]["drainAmount"], flowRate * vertexData[#]["waterLevel"]] & /@ neighborhood[[k + 1 ;;]];
]

CalculateGraphNewWaterLevels[graph_Graph] := calculateNeighborhoodNewWaterLevels[graph, #, 0.9] & /@ VertexList[graph]

UpdateGraphWaterLevels[graph_Graph] := (
  vertexData[#]["waterLevel"] = Mean[vertexData[#]["drainAmount"]];
  vertexData[#]["drainAmount"] = {}
) & /@ VertexList[graph]

FullUpdateGraph[graph_Graph] := (CalculateGraphNewWaterLevels[graph]; UpdateGraphWaterLevels[graph]; vertexData)

Neighbors[graph_Graph, vertex_List] := VertexOutComponent[graph, vertex, 1]

GenerateWaterData[graph_Graph, iterations_] := Module[{data},
    data = {};
    Do[
        AppendTo[data, FullUpdateGraph[graph]],
        {i, iterations}
    ];
    data
]


EndPackage[]
