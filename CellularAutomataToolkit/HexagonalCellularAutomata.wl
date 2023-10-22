BeginPackage["HexagonalCellularAutomata`"]

(* Usage messages for exported functions *)
HexagonalGraphGen::usage = "HexagonalGraphGen[n, m] generates a hexagonal graph of dimensions n x m.";

InitializeCellularAutomata::usage = "InitializeCellularAutomata[geoPosition, geoRange, nodeDensity, waterLevelFunction] initializes the cellular automata for a given geographical position.";

InitVertexData::usage = "InitVertexData[graph, groundHeightFunction, waterLevelFunction] initializes vertex data using given height and water level functions. Do not use if you call InitializeCellularAutomata";

VisualizeWaterData::usage = "VisualizeWaterData[graph, vertexData] visualizes water data for a given graph. VisualizeWaterData[graph, vertexData, waterLevelSizeWeight, groundLevelSizeWeight] can be used to give the water leven and ground height different weights when visualizing.";

VisualizeWaterData3D::usage = "VisualizeWaterData3D[graph, vertexData] provides a 3D visualization of water data. VisualizeWaterData3D[graph, vertexData, waterLevelScale, groundHeightScale] can be used to give the water leven and ground height different weights when visualizing.";

GenerateWaterData::usage = "GenerateWaterData[graph, iterations, flowRate] simulates the cellular automata for a given number of iterations and returns the water data.";

Begin["`Private`"] (* Begin Private Context *)

vertexData=Nothing;

NearestHexPoints[point_, coordinates_] := 
  Map[UndirectedEdge[point, #] &, Nearest[coordinates, point, {7, 2}]][[2 ;;]]

CalculateNeighborhoodNewWaterLevels[graph_Graph, vertex_List, flowRate_] := Module[
  {neighborhood, W, H, k = 1, heights, assoc},
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

CalculateGraphNewWaterLevels[graph_Graph, flowRate_] := CalculateNeighborhoodNewWaterLevels[graph, #, flowRate] & /@ VertexList[graph]

UpdateGraphWaterLevels[graph_Graph] := (
  vertexData[#]["waterLevel"] = Mean[vertexData[#]["drainAmount"]];
  vertexData[#]["drainAmount"] = {}
) & /@ VertexList[graph]

FullUpdateGraph[graph_Graph, flowRate_] := (CalculateGraphNewWaterLevels[graph, flowRate]; UpdateGraphWaterLevels[graph]; vertexData)

Neighbors[graph_Graph, vertex_List] := VertexOutComponent[graph, vertex, 1]

End[] (*End private context*)

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
  {graphLength, graph, coefficient, geoCoordinatesOfEachNode, heights},
  graphLength = Sqrt[nodeDensity]*geoRange;
  graph = HexagonalGraphGen[graphLength, graphLength];
  coefficient = geoRange/VertexList[graph][[-1]][[1]];
  geoCoordinatesOfEachNode = (geoPosition[[1]] - {geoRange, geoRange}/2 + #*coefficient) & /@ VertexList[graph];
  heights = QuantityMagnitude@GeoElevationData[GeoPosition[geoCoordinatesOfEachNode],UnitSystem -> "Metric"];
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

GenerateWaterData[graph_Graph, iterations_, flowRate_] := Module[{data},
    data = {};
    Do[
        AppendTo[data, FullUpdateGraph[graph, flowRate]],
        {i, iterations}
    ];
    data
]


EndPackage[]
