# Introduction

Welcome to the WaterGate documentation! WaterGate is an accessible computational analysis of flooding patterns written in the Wolfram Language. 
The functions range from using ReliefPlots and Morphological Branch Points to Hexagonal and Rectangular cellular automata. Watergate was inspired by the recent floods in North India, particularly in the **Himalayas**, and in my hometown of **Delhi**.

The project is currently being implemented by the **Indian Space and Research Organisation**, and I'm also working with **Dr**. **Mohammad Ali Ghorbani** from the **University of Tabriz**, a top university for Water-Engineering, to predict the morphological changes lakes present in arid regions using Convolutional Neural Networks, Time Series and Pixel-Manipulation. 

# Collaborators 
1. First Authors: Navvye Anand, George Cheng
2. Second Authors: Tyler Rose, Sophia Zhou

<p align = "center">
<img src = "https://i.ibb.co/KN4PkwZ/Water-Gate-1.png" width = "300" height = "480">
<img src = "https://i.ibb.co/sQ7sQFJ/Water-Gate-2.png" width = "300" height = "480">
</p>
<p align = "center">
<img src = "https://i.ibb.co/0KW8DcP/Water-Gate-3.png" width = "300" height = "480">
<img src = "https://i.ibb.co/nzKnxkf/Water-Gate-4.png" width = "300" height = "480">
</p>

# Abstract
240 million people are affected by floods each year, reflecting the urgent need for accessible flood prediction and detection. WaterGate is a computational model that uses geographic elevation data and the rational method to predict flooding patterns , generating an interactive 3D model for user accessibility. Computational hydrology applies numerical methods, machine learning algorithms, and computational simulations to understand, predict, and manage water resources - including floods. Our project employs computational hydrology by analyzing the structure of river tributaries in 2D through polygon clustering, satellite imaging, and various cleaning protocols. We developed respective tributary tree graphs, morphological graphs, and nodes to create a comprehensive tree and 3D model. Afterward, we examine the morphology of flood plains in 3D space, implementing the rational method (Q = C iA) framework with curated relief plots to predict, model, and visualize flooding elevation. Then, we constructed our stream order analysis, waterline delineation, and statistical analysis to validate our data. Lastly, we modeled different river systems and developed further extensions to increase the applicability of WaterGate to communities around the world.

# Table of Contents 
- [Abstract](#abstract)
- [Documentation](#documentation)
  * [Isolating Rivers from Maps](#isolating-rivers-from-maps)
  * [Creating Morphological Graphs and Tree Graphs](#creating-morphological-graphs-and-tree-graphs)
  * [Finding Stream Splits on Morphological Graphs](#finding-stream-splits-on-morphological-graphs)
  * [Mapping River Branches on Maps](#mapping-river-branches-on-maps)
  * [Application to Simple River Systems](#application-to-simple-river-systems)
  * [Application to Complex River Systems](#application-to-complex-river-systems)
  * [2-D Satellite Mapping onto 3-D Model](#2-d-satellite-mapping-onto-3-d-model)
  * [Relief Plot for Flood Plain](#relief-plot-for-flood-plain)
  * [Rational Method (Q = CiA) Introduction and Usage](#rational-method--q---cia--introduction-and-usage)
  * [C Calculation](#c-calculation)
  * [I Calculation](#i-calculation)
  * [A Calculation](#a-calculation)
  * [CiA (Q Calculation) & River Runoff Calculation](#cia--q-calculation----river-runoff-calculation)
  * [Relief Calculation Integration and Flood Analysis](#relief-calculation-integration-and-flood-analysis)
  * [Application to Simple River Systems](#application-to-simple-river-systems-1)
  * [Application to Complex River Systems](#application-to-complex-river-systems-1)
  * [Tying Everything Together Part I](#tying-everything-together-part-i)
  * [2D & 3D Population Density Model](#2d---3d-population-density-model)
  * [Large Scale Modeling of River Width](#large-scale-modeling-of-river-width)
  * [Using Bridges and Their Data](#using-bridges-and-their-data)
  * [Study of Bridges in Cities](#study-of-bridges-in-cities)
    + [Bridge Density](#bridge-density)
  * [Using Dams and their Data](#using-dams-and-their-data)
    + [An Attempt to Compute the Volume & Area of Dam using Satellite Images](#an-attempt-to-compute-the-volume---area-of-dam-using-satellite-images)
      - [Finding Area](#finding-area)
      - [Finding Depth](#finding-depth)
        * [a) Using pure bathymetric functions](#a--using-pure-bathymetric-functions)
        * [b) Using Neural Networks](#b--using-neural-networks)
    + [Plotting Dams & Bridges on the same Map](#plotting-dams---bridges-on-the-same-map)
  * [Tying Everything Together Part II](#tying-everything-together-part-ii)
  * [Creating Stream Order from Tree Graphs](#creating-stream-order-from-tree-graphs)
  * [Statistical Analysis](#statistical-analysis)
  * [Using Real Time Satellite Imagery to Calculate Change in Water Levels](#using-real-time-satellite-imagery-to-calculate-change-in-water-levels)
    + [Introduction to OpenWeatherMap](#introduction-to-openweathermap)
    + [Explaining the API Process](#explaining-the-api-process)
      - [Creating a Polygon using GeoJSON Coordinates](#creating-a-polygon-using-geojson-coordinates)
    + [Calculating Change in Water Levels](#calculating-change-in-water-levels)
  * [Watershed Delineation](#watershed-delineation)
  * [Using cellular automata](#using-cellular-automata)
    + [Introduction](#introduction)
      - [Locations](#locations)
    + [Elevation Bathtub Model](#elevation-bathtub-model)
      - [Atlantic City](#atlantic-city)
      - [Delaware River](#delaware-river)
    + [Cellular Automata Overview](#cellular-automata-overview)
    + [Simple Cellular Automata Model](#simple-cellular-automata-model)
      - [Rule](#rule)
      - [Data](#data)
      - [Step By Step Model](#step-by-step-model)
          + [Helper Functions:](#helper-functions-)
          + [Rule Function](#rule-function)
        * [Visualization](#visualization)
    + [Weighted Cellular Automata Model](#weighted-cellular-automata-model)
      - [Data](#data-1)
      - [Steps](#steps)
        * [Identifying Downstream Cells](#identifying-downstream-cells)
      - [Weight Computing](#weight-computing)
      - [Total Intercellular-Volume](#total-intercellular-volume)
        * [Helper Functions](#helper-functions)
      - [Depth Updating](#depth-updating)
      - [Data Visualization](#data-visualization)
        * [Atlantic City](#atlantic-city-1)
        * [Princeton](#princeton)
    + [HexagonalCellularAutomata Documentation](#hexagonalcellularautomata-documentation)
      - [HexagonalGraphGen](#hexagonalgraphgen)
      - [InitializeCellularAutomata](#initializecellularautomata)
      - [InitVertexData](#initvertexdata)
      - [VisualizeWaterData](#visualizewaterdata)
      - [VisualizeWaterData3D](#visualizewaterdata3d)
      - [GenerateWaterData](#generatewaterdata)
      - [Internal-Functions](#internal-functions)
    + [Conclusion](#conclusion)
    


# Documentation 
This will not be a traditional documentation - rather, it will focus on the code that we've written and how you can implement it if you code in the Wolfram Language

## Isolating Rivers from Maps 
This first step of this section is to find a way to isolate rivers from a Map; we can do this through polygon clusters and color recognition. VectorMinimal allows us to convert individual components on the map into manipulable polygons. GeoBoundingBox gives the coordinates of the bounding rectangle enclosing the extracted polygon. GeoGraphics simply gives the map of all said polygons in the region. 

```Mathematica
parisMapData = 
 GeoGraphics[
  GeoBoundingBox[Entity["City", {"Paris", "IleDeFrance", "France"}]], 
  GeoBackground -> "VectorMinimal"]

parisMap = ImageResize[parisMapData, 500]
```
<p align = "center"> 
<img width="370" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/9297589e-d3ff-4b16-850a-b76047624e71">
 </p>
Which gives the abovementioned output.

Now, we can take the color of the river on parisMap, RGBColor[0.6, 0.807843137254902, 1.0]  and extract all polygons that match the criteria of that color. Specifically, we will employ Cases and Select to parse through the objects with {} color with the condition Not @ * FreeQ[Polygon] to iterate through parisMap until there are no more "Free" {}polygons.

```Mathematica
riverParis = 
 Graphics[
  Select[Cases[
    parisMapData, {Directive[{___, 
       RGBColor[0.6, 0.807843137254902`, 1.], ___}], ___}, Infinity], 
   Not@*FreeQ[Polygon]]]
```
<p align = "center"> 
<img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/3615439d-b01a-4101-878f-303a9d72ad03">

</p>
However, this function extracts all the blue polygons in the map --- this includes the extraneous water structures separate from the main river and its tributaries. We can fix this through cleaning functions like Dilation (to enlarge all components to connect river polygons), DeleteSmallComponents (to delete all the unconnected, small components), and Thinning (to return the river back to a manageable size).

```Mathematica
parisOutline =
 Thinning[
  DeleteSmallComponents[
   Dilation[
    ColorNegate[
     Binarize[
      Graphics[
       Flatten[Cases[parisMapData, 
         water : {Directive[{___, 
              RGBColor[0.6, 0.807843137254902`, 1.], ___}], ___} :> 
          water[[2]], Infinity]]]]], 3]]]
```
<p align = "center"> 
<img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/89d4651c-1546-4023-8f92-82cd9235e53d">
</p>

## Creating Morphological Graphs and Tree Graphs

We can apply MorphologicalGraph to parisOutline to give an undirected graph that represents the connectivity of the morphological branch points and endpoint
```Mathematica
parisMorphologicalGraph = MorphologicalGraph[parisOutline]
```
<p align = "center"> 
<img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/a36fee43-1c4d-46e6-aeb3-9a6d519c3220">
</p>
There are a few major flaws in the parisMorphologicalGraph, however. To overcome this limitation and make the morphological graph acyclic, we can employ the TransitiveReductionGraph function. The TransitiveReductionGraph function works by iteratively eliminating edges that contribute to cycles while preserving the graph's reachability properties; it identifies and removes edges that are transitively implied by other edges in the graph, effectively reducing the number of edges and transforming cyclic components into acyclic ones.

<p align = "center"> 
<img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/8be115a4-ba0b-4c41-8dbb-b1ba9a4c7389">
</p>

## Finding Stream Splits on Morphological Graphs

Finding stream splits through morphological graphs can easily be done using MorphologicalBranchPoints and various data cleaning mechanism. First, we extract the river polygons (this time using pattern matching as it reduces the time complexity); next we Binarize the image and subject it to ColorNegate to turn the river white and the background black. Afterwards, we apply the Dilation function to connect all the river polygons together and use the function DeleteSmallComponents to remove extraneous water sources.  We apply Thinning to return the river to the original size before using the function MorphologicalBranchPoints to point out the pixels that form river splits. Lastly, we dilate the points and make them into circles using Dilatation (once more) and DiskMatrix

```Mathematica
branchIdentification =
  Dilation[
   MorphologicalBranchPoints[
    Thinning[
     DeleteSmallComponents[
      Dilation[
       ColorNegate[
        Binarize[
         
         Graphics[
          Flatten[Cases[parisMapData, 
            water : {Directive[{___, 
                 RGBColor[0.6, 0.807843137254902`, 1.], ___}], ___} :>
              water[[2]], Infinity]]]]], 3]]]], DiskMatrix[5]];

branchPoints = 
 RemoveBackground[
  ColorReplace[ColorNegate[branchIdentification], Black -> Red]]
```
<p align="center">
  <img src="https://github.com/navvye/WaterGate/assets/25653940/bae7d44e-d308-43ee-840e-5561a8afe4d5" width="360" />
  <img src="https://github.com/navvye/WaterGate/assets/25653940/c82450ce-bb1a-4b9b-9182-f0094caba379" width="360" /> <br>
Branch Points in red and black.
</p>

```Mathematica
riverParis = 
  Graphics[
   Select[Cases[
     parisMapData, {Directive[{___, 
        RGBColor[0.6, 0.807843137254902`, 1.], ___}], ___}, Infinity],
     Not@*FreeQ[Polygon]]];
layoverImage = ImageCompose[riverParis, branchPoints]
```
<p align="center">
 <img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/59365ed3-2ce7-4e4f-b287-e8fdeda3464b"> <img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/17589e62-c505-4165-9b3c-cf7e7ff85d7c"> 
</p>
<p align ="center">  
River Marne with and without branchpoints
</p>

## Mapping River Branches on Maps

Although the process for evaluating polygons on maps is known, extracting the polygons across a multitude of different maps (with different coloring schemes) is not trivial. Therefore, we first define variables that extract raw data from the map and stores them for them to be manipulated later. We used the functions Nearest and ColorReplace to make the association from the river's blue to our desired blue. 

GeoToGraphicsLayer helps with the syntax of the extraction of graphics layers from a map using functions like Flatten and Cases. The rest of the riverBranchMap pure anonymous function is written so that the code can be applied to other river systems; x_, y_, and z_ variables indicate the city, state/province, and country, respectively, and the f_ variable changes the GeoRange the map takes in. The process involves the same polygon extraction and cleaning protocols detailed above (for both the red nodes along the river tributary splits and the river tributaries themselves) and alignment onto the map.

```Mathematica
riverBranchMap[{x_, y_, z_}, f_] :=
 Graphics[
  ImageCompose[
   ImageCompose[
    Graphics[
     Values[GeoToGraphicsLayers[
       GeoGraphics[GeoToGraphicsLayers[Entity["City", {x, y, z}]], 
        GeoBackground -> "VectorMinimal", 
        GeoRange -> Quantity[f, "Miles"], GeoRangePadding -> None]]]],
     RemoveBackground[
     ColorReplace[
      Graphics[
       Lookup[GeoToGraphicsLayers[
         GeoGraphics[GeoBoundingBox[Entity["City", {x, y, z}]], 
          GeoBackground -> "VectorMinimal", 
          GeoRange -> Quantity[f, "Miles"], GeoRangePadding -> None]],
         Nearest[
          Keys[GeoToGraphicsLayers[
            GeoGraphics[GeoBoundingBox[Entity["City", {x, y, z}]], 
             GeoBackground -> "VectorMinimal", 
             GeoRange -> Quantity[f, "Miles"], 
             GeoRangePadding -> None]]
           ], Blue][[1]]]], waterColor -> Darker[waterColor, .3]]], 
    Center, Center, {1, .4, 1}], 
   ColorReplace[
    RemoveBackground[
     ColorNegate[
      Dilation[
       MorphologicalBranchPoints[
        Thinning[
         Dilation[
          DeleteSmallComponents[
           ColorNegate[
            Binarize[
             Graphics[
              Lookup[GeoToGraphicsLayers[
                GeoGraphics[GeoBoundingBox[Entity["City", {x, y, z}]],
                  GeoBackground -> "VectorMinimal", 
                 GeoRange -> Quantity[f, "Miles"], 
                 GeoRangePadding -> None]], 
               Nearest[Keys[
                  GeoToGraphicsLayers[
                   GeoGraphics[
                    GeoBoundingBox[Entity["City", {x, y, z}]], 
                    GeoBackground -> "VectorMinimal", 
                    GeoRange -> Quantity[f, "Miles"], 
                    GeoRangePadding -> None]]
                  ], Blue][[1]]]]]]], 2]]], DiskMatrix[5]]]], 
    Black -> Red]], ImageSize -> Large]

```
A massive Wolfram-Languagey function that compiles everything into one (Functional Programming for the win!)
<p align = "center"> 
<img width="576" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/cce7887d-c103-45a3-8b50-3e9d856c26b9">
</p>

## Application to Simple River Systems

Application of this code to simple river systems can present us with overlooked overcomplexity. Tributaries may be over counted, small bodies of water may be presented as a multiple tributaries. But overall, the code works perfectly fine when applied to simple river systems. 

```Mathematica
mapView[{x2_, y2_, z2_}] := 
 GeoGraphics[GeoBoundingBox[Entity["City", {x2, y2, z2}]], 
  GeoBackground -> "VectorMinimal"]

mapView[{"Jackson", "Mississippi", "UnitedStates"}]
```

<p align = "center"> 
<img width="420" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/3a05e8d2-482f-48cf-a548-91ee84a849f0">
</p>

```Mathematica
polygonComponents[{"Jackson", "Mississippi", "UnitedStates"}]

polygonComponents[{x3_, y3_, z3_}] := 
 Graphics[
  Select[Cases[
    GeoGraphics[GeoBoundingBox[Entity["City", {x3, y3, z3}]], 
     GeoBackground -> 
      "VectorMinimal"], {Directive[{___, 
       RGBColor[0.6, 0.807843137254902`, 1.], ___}], ___}, Infinity], 
   Not@*FreeQ[Polygon]]]

```
<p align = "center"> 
<img width="299" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/7b2ba3d8-2713-4618-b4fc-e1bee0dd1b30"> <img width="287" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/a3f0f230-9714-41c6-9850-1f43cadebbfb">
</p>

We'll turn the image into a morphological graph using the threeDFullfunction through MorphologicalGraph and Graph3D:

```Mathematica
threeDFullFunction[{x6_, y6_, z6_}] :=
 Graph3D[
  MorphologicalGraph[
   Thinning[
    DeleteSmallComponents[
     Dilation[
      ColorNegate[
       Binarize[
        Graphics[
         Flatten[Cases[
           GeoGraphics[GeoBoundingBox[Entity["City", {x6, y6, z6}]], 
            GeoBackground -> "VectorMinimal"], 
           water : {Directive[{___, 
                RGBColor[0.6, 0.807843137254902`, 1.], ___}], ___} :> 
            water[[2]], Infinity]]]]], 3]]]]]
threeDFullFunction[{"Jackson", "Mississippi", "UnitedStates"}]
```
<p align = "center"> 
<img width="260" height = "360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/8bcb5552-ecc8-4bd4-be13-aaddc437382d">
<img width="260" height = "360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/873fdd03-8279-4027-9bcf-23401b2f4601">
</p>


## Application to Complex River Systems

Application of this code to more complex river systems may present even more challenges. Tributaries may be uncounted, large bodies of water may be presented as a single tributary, and tree graphs may be inaccurate. Note that this example was created in a pure anonymous function for the purpose that this code can be applied to other locations.



```Mathematica 
mapView[{x9_, y9_, z9_}] := 
  GeoGraphics[GeoBoundingBox[Entity["City", {x9, y9, z9}]], 
   GeoBackground -> "VectorMinimal"];
mapView[{"Anchorage", "Alaska", "UnitedStates"}]
```
<p align = "center"> 
<img width="420" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/93eefe56-7115-435a-b4b4-1de568ec2d2f">
</p>

Then, we'll apply Binarize through the polygonBinarization function to polygonComponents to prepare it for cleaning:
```Mathematica
polygonBinarization[{x11_, y11_, z11_}] := ColorNegate[
  Binarize[
   Graphics[
    Flatten[Cases[
      GeoGraphics[GeoBoundingBox[Entity["City", {x11, y11, z11}]], 
       GeoBackground -> "VectorMinimal"], 
      water : {Directive[{___, 
           RGBColor[0.6, 0.807843137254902`, 1.], ___}], ___} :> 
       water[[2]], Infinity]]]]]
polygonBinarization[{"Anchorage", "Alaska", "UnitedStates"}]
```
After, we'll apply Dilation, DeleteSmallComponents, and Thinning through the polygonCleaning function to clean all unconnected, small components:
```Mathematica
polygonCleaning[{x12_, y12_, z12_}] := Thinning[
  DeleteSmallComponents[
   Dilation[
    ColorNegate[
     Binarize[
      Graphics[
       Flatten[Cases[
         GeoGraphics[GeoBoundingBox[Entity["City", {x12, y12, z12}]], 
          GeoBackground -> "VectorMinimal"], 
         water : {Directive[{___, 
              RGBColor[0.6, 0.807843137254902`, 1.], ___}], ___} :> 
          water[[2]], Infinity]]]]], 3]]]
polygonCleaning[{"Anchorage", "Alaska", "UnitedStates"}]
```
<p align = "center"> 
 <img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/261ddf84-5b52-4cef-8384-cff79cb4174b">
 <img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/53e149bf-5829-45ef-a5dc-4485f30dc5b2">
</p>

<p align = "center" > We'll turn the image into a morphological graph </p>

```Mathematica
threeDFullFunction[{x13_, y13_, z13_}] :=
 Graph3D[
  MorphologicalGraph[
   Thinning[
    DeleteSmallComponents[
     Dilation[
      ColorNegate[
       Binarize[
        Graphics[
         Flatten[Cases[
           GeoGraphics[
            GeoBoundingBox[Entity["City", {x13, y13, z13}]], 
            GeoBackground -> "VectorMinimal"], 
           water : {Directive[{___, 
                RGBColor[0.6, 0.807843137254902`, 1.], ___}], ___} :> 
            water[[2]], Infinity]]]]], 3]]]]]

threeDFullFunction[{"Anchorage", "Alaska", "UnitedStates"}]
```

<p align = "center" > <img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/3be603b2-554e-4177-b17e-a1c53ed9c51f">
 <img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/cfa661fc-67a3-413b-a34c-6184d6fdfc38">
</p>
<p align = "center" > Acyclic and Cyclic Morphological Graphs </p>


## 2-D Satellite Mapping onto 3-D Model 

The first step of this section is to find a way to take satellite imagery of a geographic location using GeoImage; afterwards, we will extract the river basin using imaging processing (using Color Matching once more) and layer both the satellite image and the river (using ImageCompose) to create a texture that could be mapped onto ListPlot3D to create a chunk of the specified geographic location. Let's see an example in Juneau, Alaska, we name it satelliteImage:

```Mathematica
satelliteImage = 
 GeoImage[Entity["City", {"Juneau", "Alaska", "UnitedStates"}], 
  GeoRange -> Quantity[10, "Miles"]]
```
<p align = "center" > <img width="436" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/91c49b2d-5eb3-4b52-9199-1963284861c0"> </p>

Afterwards, we can extract the river information from a street map through GeoImage. Then, we can clean the data using ColorNegate, Binarize, and ImageRecolor. ColorNegate and Binarize makes its so that only the river component of satelliteImage is present. ImageRecolor recolors the black (from ColorNegate) into a more desirable blue color for the river. StreeMapNoLabels takes away the labels from the street map to foster a more fluid  transition from map to river image.

```Mathematica
riverImage = 
 ImageRecolor[
  Binarize[
   ColorNegate[
    GeoImage[Entity["City", {"Juneau", "Alaska", "UnitedStates"}], 
     "StreetMapNoLabels", 
     GeoRange -> Quantity[10, "Miles"]]]], {White -> 
    RGBColor[0, 0, Rational[2, 3], 0.5], 
   Black -> RGBColor[0.5, 0.5, 0.5, 0]}]
```
<p align = "center" > <img width="443" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/dd2fa0f0-cd3e-4086-9e52-367dcba9a34c"> </p>
Then, we will overlay satelliteImage and riverImage through the ImageCompose function.

```Mathematica 
fullSatelliteImage = ImageCompose[satelliteImage, riverImage]
```

<p align = "center" > <img width="438" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/70a2f72d-4220-40fd-ae20-205e8e5f8d53">
 </p>

Finally, we can set the overlay as a texture scope and create a ListPlot3D for the entire satellite image. 

```Mathematica

ListPlot3D[
 GeoElevationData[
  Entity["City", {"Juneau", "Alaska", "UnitedStates"}], 
  GeoRange -> Quantity[10, "Miles"]], MeshFunctions -> {#3 &}, 
 PlotRange -> All, 
 PlotStyle -> Texture[ImageRotate[fullSatelliteImage, 3 Pi/2]], 
 Filling -> Bottom, FillingStyle -> Opacity[1], ImageSize -> 1000]
```
<p align = "center " > <img width="466" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/a4f02f2f-073b-416d-83bf-bf5f90290c1c"> </p>

## Relief Plot for Flood Plain

A relief plot can be especially helpful to model the flood plain of a particular area. We can apply the function MinMax to find the range of the manipulate, ColorReplace to fill in the "flooded" space with RGBColor[0.6, 0.807843137254902, 1.0]  and Dynamic@ to synchronously reflect the changes made.

```Mathematica
Manipulate[ReliefPlot[juneauData, PlotRange -> {rainfall, ma}], 
  {rainfall, -1434.796150587988, 6732.8241303211125}, 
  SynchronousUpdating -> True, SynchronousInitialization -> True, 
  LocalizeVariables -> False]
```

<p align = "center"> <img src = "https://github.com/navvye/WaterGate/assets/25653940/98a35812-d4f9-487a-8e63-0392b0458870" /> </p>

We can set the overlay as a texture scope and create a ListPlot3D for the entire relief plot. 

```Mathematica
ListPlot3D[
 GeoElevationData[
  Entity["City", {"Juneau", "Alaska", "UnitedStates"}], 
  GeoRange -> Quantity[10, "Miles"]], MeshFunctions -> {#3 &}, 
 PlotRange -> All, PlotStyle -> Texture[juneauReliefTrue], 
 Filling -> Bottom, FillingStyle -> Opacity[1], ImageSize -> 1250]
```
<p align = "center" > <img width="367" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/956a7bf0-fdf9-4a97-bf8b-e42bdda479a8"></p>


## Rational Method (Q = CiA) Introduction and Usage

The rational method  is used for determining peak discharges; this method is traditionally used to size storm sewers, channels, and other stormwater structures.

The rational method formula is expressed as Q = CiA where: Q = Peak rate of runoff in cubic feet per second; C = Runoff coefficient, an empirical coefficient representing a relationship between rainfall and runoff; i = Average intensity of rainfall in inches per hour for the time of concentration for a selected frequency of occurrence or return period; A = The watershed area in acre. In this section, we will be calculating each of these variables and parameterizing them for any geographic location. 
## C Calculation
As C is the runoff coefficient, we conducted a weighted average for all the colors present in the map with their coefficients taken from this table:

<p align = "center" >
 <img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/e4c03bb1-de0b-4e28-bf10-22cf802476fa"> 
</p>

As colors from different regions may differ, we have to build an algorithm that converts the closest color to the colors in our key. Using Nearest and ReplaceAll we are able to associate the correct colors with the correct weights. Afterwards we can see the color coverage of all the regions in the map using "Color" and "Coverage" as the option for the DominantColors function and apply the weight to get our final C value.

```Mathematica
juneauGeo = 
 GeoGraphics[
  GeoBoundingBox[
   Entity["City", {"Juneau", "Alaska", "UnitedStates"}]], 
  GeoBackground -> "VectorMinimal", GeoRange -> Quantity[20, "Miles"],
   GeoRangePadding -> None]; juneauDominantColorsCity = 
 DominantColors[juneauGeo, 5];
juneauCanonicalColorValueMap = {RGBColor[
    0.9485373223930705, 0.9487508349546278, 0.9489485072522973, 1.] ->
     0.8, RGBColor[
    0.6313832857283339, 0.7646670368551112, 0.498099288620747, 1.] -> 
    0.25, RGBColor[
    0.9997462475099389, 0.8507363495836935, 0.3998398617073094, 1.] ->
     0.85, RGBColor[
    0.9993720538256167, 0.7492570006072168, 0.003109412403643569, 
     1.] -> 0.65, 
   RGBColor[
    0.2960132375888991, 0.2960131125158366, 0.2960131444661215, 1.] ->
     0.8, RGBColor[
    0.6000193760698551, 0.8071089170241192, 0.998613272437677, 1.] -> 
    0.01, RGBColor[
    0.09982824341023538, 0.3304382676154282, 0.6514924833695483, 
     1.] -> 0.01, 
   RGBColor[
    0.6540282036622517, 0.6540488377301875, 0.6540691378617204, 1.] ->
     0.75};
juneauCleanupRules = 
  MapThread[
   Rule, {Flatten@
     Nearest[Keys@juneauCanonicalColorValueMap, 
      juneauDominantColorsCity], juneauDominantColorsCity}];
juneauCityValueMap = 
  juneauCanonicalColorValueMap /. juneauCleanupRules;
juneauCityColorCoverage = 
  DominantColors[juneauGeo, 5, {"Color", "Coverage"}];
Transpose[juneauCityColorCoverage /. juneauCityValueMap];
juneauCityWeightedByColor = 
  WeightedData @@ 
   Transpose[juneauCityColorCoverage /. juneauCityValueMap];

juneauPermeability = Mean[juneauCityWeightedByColor]

```
Which gives us C = 0.633755

## I Calculation

I is the intensity of the rainfall. Previous literature found that the intensity of rainfall for flash floods is usually around 4-6 inches; by taking the rainfall data using WeatherData for the past 20+ years, we are able to find an average annual rainfall measured in centimeters (which we converted to inches by dividing by 2.54). Next we mapped the intensity of rainfall (if it were to flood) and set it proportional to how high the annual rainfall is using a Which function.

```Mathematica

juneauIntensity = 
  Mean[WeatherData[
     Entity["City", {"Juneau", "Alaska", "UnitedStates"}], 
     "TotalPrecipitation", {{2000, 1, 1}, {2022, 12, 31}, "Year"}]]/
   2.54;

juneauIntensityCalibrated = 
 Which[0 < juneauIntensity < 5, 4.1 , 5 < juneauIntensity < 10, 4.2 , 
  10 < juneauIntensity < 15, 4.3 , 15 < juneauIntensity < 20, 4.4, 
  20 < juneauIntensity < 25, 4.5 , 25 < juneauIntensity < 30, 4.6 , 
  130 < juneauIntensity < 35, 4.7 , 35 < juneauIntensity < 40, 4.8 , 
  40 < juneauIntensity < 45, 4.9 , 45 < juneauIntensity < 50, 5.0 , 
  50 < juneauIntensity < 55, 5.1 , 55 < juneauIntensity < 60, 5.2 , 
  60 < juneauIntensity < 65, 5.3 , 65 < juneauIntensity < 70, 5.4 , 
  70 < juneauIntensity < 75, 5.5 , 75 < juneauIntensity < 80, 5.6 , 
  80 < juneauIntensity < 85, 5.7 , 85 < juneauIntensity < 90, 5.8 , 
  90 < juneauIntensity < 95, 5.9 , 95 < juneauIntensity < 100, 6.0]
```
Which gives us I = 4.9

## A Calculation

A is the area of the flood plain in acres; current data was in miles. To convert miles to acres, we have to square the region boundaries (the return result will be in square miles), then multiply by 640.
```Mathematica
juneauAcres = 20^2*640
```
Which gives us A = 256000

## CiA (Q Calculation) & River Runoff Calculation

```Mathematica
In[247]:= juneauPeakRunoff = 
 juneauPermeability*juneauIntensityCalibrated*juneauAcres

Q = 794982.
```
Now, we want to multiply the peakRunoff calculation (Q) by the inverse to model the factor in which the river will increase with respect to time. Then, we'll convert 400 square mile to 11,151,360,000 square feet and multiply  3600 to convert seconds to hours (the original measurement of Q is cubic feet/second). This measurement will give us the units measurement of feet/hour, in which we can manipulate the amount of hours the flood occurs to give the totalRiverIncrease.

```Mathematica
juneauTotalRiverIncrease = 
 riverRunoffCalculator[{"Juneau", "Alaska", "UnitedStates"}, 750]
riverRunoffCalculator[{x_, y_, z_}, h_] :=
 (juneauPeakRunoff/
     Part[Part[#, 2] & /@ 
       Select[DominantColors[
         GeoGraphics[GeoBoundingBox[Entity["City", {x, y, z}]], 
          GeoBackground -> "VectorMinimal", 
          GeoRange -> Quantity[20, "Miles"], GeoRangePadding -> None],
          5, {"Color", "Coverage"}], 
        ColorDistance[RGBColor[
           0.5998694708331431, 0.8076220271551392, 0.9996520209699861,
             1.], #[[1]]] < 0.1 &], 1])/11151360000*3600*h
```
1422.29 => Elevation increase is 1422.29 feet increase if it rained for 750 hours straight in Juneau, Alaska

## Relief Calculation Integration and Flood Analysis 

Taking our previous ReliefPlot techniques, here is the plot for Juneau for the environment specifications, named juneauElevation:

```Mathematica
juneauElevation = 
  GeoElevationData[
   Entity["City", {"Juneau", "Alaska", "UnitedStates"}], 
   GeoRange -> Quantity[20, "Miles"], GeoProjection -> Automatic, 
   UnitSystem -> "Imperial"];
{mi, ma} = QuantityMagnitude[MinMax[juneauElevation]];
juneauLevelPlot = 
 ColorReplace[
  ReliefPlot[juneauElevation, 
   PlotRange -> {mi + juneauTotalRiverIncrease, ma}], 
  White -> 
   Directive[RGBColor[0.6, 0.807843137254902`, 1.], Opacity[0.2]]]

```
<p align = "center"> 
<img width="250" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/3262c545-bc53-48ab-9803-064fe6b0346e">
</p>

We can then map both the alaskaElevation relief plot and use the totalRiverIncrease data to create a 3D flood plain using ListPlot3D. We used the function Show to overlay the flood plain with the created ListPlot3D of Juneau, Alaska; the first argument created the terrain and the second argument created the rising flood plain with respect to the totalRiverIncrease. Then, we added some minor formatting to the plot (Filling, FillingStyle, PlotStyle) for visualization purposes.


```Mathematica
Show[ListPlot3D[
  GeoElevationData[
   Entity["City", {"Juneau", "Alaska", "UnitedStates"}], 
   GeoRange -> Quantity[20, "Miles"]], MeshFunctions -> {#3 &}, 
  PlotRange -> All, PlotStyle -> Texture[juneauLevelPlot], 
  Filling -> Bottom, FillingStyle -> Opacity[1], ImageSize -> 1250], 
 Plot3D[{mi, mi + juneauTotalRiverIncrease}, {x, 0, 800}, {y, 0, 425},
   PlotStyle -> Opacity[0.5, RGBColor[0.6, 0.807843137254902`, 1.]], 
  Filling -> Bottom, FillingStyle -> Opacity[0.5]]]
```
<p align = "center"> <img width="494" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/088c38c0-c169-43fa-9cc8-ebaa6bdefc9c">
</p>

## Application to Simple River Systems

Simple river systems may present challenges to the flood plain analysis: rural landscapes may erroneously increase the complexity the mapping process, providing wrong measurements of rainfall and flooding elevation. These problems may cause the prediction to be inaccurate, hence our motivation to apply the code generally to all locations through better cleaning algorithms. Note that we added the parameter cityDimensions to make the plot ranging inclusive of all points in the 20 by 20 mile area.

Let's explore an example in Jackson, Mississippi, using the measurements taken from dominantColorsCity, canonicalColorValueMap, cleanupRules, cityColorCoverage, cityWeightedByColor, permeability, intensity, intensityCalibrated, acres, peakRunoff, totalRiverIncrease:

```Mathematica
In[254]:= jacksonGeo = 
 GeoGraphics[
  GeoBoundingBox[
   Entity["City", {"Anchorage", "Alaska", "UnitedStates"}]], 
  GeoBackground -> "VectorMinimal", GeoRange -> Quantity[20, "Miles"],
   GeoRangePadding -> None]; jacksonDominantColorsCity = 
 DominantColors[jacksonGeo, 10];
jacksonCanonicalColorValueMap = {RGBColor[
    0.9485373223930705, 0.9487508349546278, 0.9489485072522973, 1.] ->
     0.8, RGBColor[
    0.6313832857283339, 0.7646670368551112, 0.498099288620747, 1.] -> 
    0.25, RGBColor[
    0.9997462475099389, 0.8507363495836935, 0.3998398617073094, 1.] ->
     0.85, RGBColor[
    0.9993720538256167, 0.7492570006072168, 0.003109412403643569, 
     1.] -> 0.65, 
   RGBColor[
    0.2960132375888991, 0.2960131125158366, 0.2960131444661215, 1.] ->
     0.8, RGBColor[
    0.6000193760698551, 0.8071089170241192, 0.998613272437677, 1.] -> 
    0.01, RGBColor[
    0.09982824341023538, 0.3304382676154282, 0.6514924833695483, 
     1.] -> 0.01, 
   RGBColor[
    0.6540282036622517, 0.6540488377301875, 0.6540691378617204, 1.] ->
     0.75};
jacksonCleanupRules = 
  MapThread[
   Rule, {Flatten@
     Nearest[Keys@jacksonCanonicalColorValueMap, 
      jacksonDominantColorsCity], jacksonDominantColorsCity}];
jacksonCityValueMap = 
  jacksonCanonicalColorValueMap /. jacksonCleanupRules;
jacksonCityColorCoverage = 
  DominantColors[jacksonGeo, 10, {"Color", "Coverage"}];
Transpose[jacksonCityColorCoverage /. jacksonCityValueMap];
jacksonCityWeightedByColor = 
  WeightedData @@ 
   Transpose[jacksonCityColorCoverage /. jacksonCityValueMap];

jacksonPermeability = Mean[jacksonCityWeightedByColor];

jacksonIntensity = 
  Mean[WeatherData[
     Entity["City", {"Anchorage", "Alaska", "UnitedStates"}], 
     "TotalPrecipitation", {{2000, 1, 1}, {2022, 12, 31}, "Year"}]]/
   2.54;

jacksonIntensityCalibrated = 
  Which[0 < jacksonIntensity < 5, 4.1 , 5 < jacksonIntensity < 10, 
   4.2 , 10 < jacksonIntensity < 15, 4.3 , 15 < jacksonIntensity < 20,
    4.4, 20 < jacksonIntensity < 25, 4.5 , 25 < jacksonIntensity < 30,
    4.6 , 130 < jacksonIntensity < 35, 4.7 , 
   35 < jacksonIntensity < 40, 4.8 , 40 < jacksonIntensity < 45, 4.9 ,
    45 < jacksonIntensity < 50, 5.0 , 50 < jacksonIntensity < 55, 
   5.1 , 55 < jacksonIntensity < 60, 5.2 , 60 < jacksonIntensity < 65,
    5.3 , 65 < jacksonIntensity < 70, 5.4 , 
   70 < jacksonIntensity < 75, 5.5 , 75 < jacksonIntensity < 80, 
   5.6 , 80 < jacksonIntensity < 85, 5.7 , 85 < jacksonIntensity < 90,
    5.8 , 90 < jacksonIntensity < 95, 5.9 , 
   95 < jacksonIntensity < 100, 6.0];


jacksonAcres = 20^2*640;

jacksonPeakRunoff = 
  jacksonPermeability*jacksonIntensityCalibrated *jacksonAcres;

jacksonTotalRiverIncrease = (jacksonPeakRunoff/
     Part[Part[#, 2] & /@ 
       Select[DominantColors[
         GeoGraphics[
          GeoBoundingBox[
           Entity["City", {"Anchorage", "Alaska", "UnitedStates"}]], 
          GeoBackground -> "VectorMinimal", 
          GeoRange -> Quantity[20, "Miles"], GeoRangePadding -> None],
          5, {"Color", "Coverage"}], 
        ColorDistance[RGBColor[
           0.5998694708331431, 0.8076220271551392, 0.9996520209699861,
             1.], #[[1]]] < 0.1 &], 1])/11151360000*3600*200

Out[266]= 152.786
```
In the jacksonGeo model, we simulated 152.786 feet of heavy rainfall over 200 hours in Jackson, Mississippi. Then, we evaluated the ReliefPlot and ListPlot3D using the peakRunoff data and we were able to determine using the rational method (Q = CiA). We now plot the Relief and 3D Models.
<p align = "center" >
 <img width="455" height = "455" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/0b5166bc-f7db-42e4-9e0b-c09cfdcbc04b">
<img width="466" height = "455" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/2450a1e6-b0c5-43f7-bbbd-57b5bcedffe4">
</p>

## Application to Complex River Systems 
Complex river systems may present challenges to the flood plain analysis: urban landscapes have varying ranges of elevation, diverse river tributaries, and sporadic weather. These problems may cause the prediction to be inaccurate, hence our motivation to apply the code generally to all locations through better cleaning algorithms. Note that we added the parameter cityDimensions to make the plot ranging inclusive of all points in the 20 by 20 mile area.

```Mathematica
In[272]:= anchorageGeo = 
 GeoGraphics[
  GeoBoundingBox[
   Entity["City", {"Anchorage", "Alaska", "UnitedStates"}]], 
  GeoBackground -> "VectorMinimal", GeoRange -> Quantity[20, "Miles"],
   GeoRangePadding -> None]; anchorageDominantColorsCity = 
 DominantColors[anchorageGeo, 10];
anchorageCanonicalColorValueMap = {RGBColor[
    0.9485373223930705, 0.9487508349546278, 0.9489485072522973, 1.] ->
     0.8, RGBColor[
    0.6313832857283339, 0.7646670368551112, 0.498099288620747, 1.] -> 
    0.25, RGBColor[
    0.9997462475099389, 0.8507363495836935, 0.3998398617073094, 1.] ->
     0.85, RGBColor[
    0.9993720538256167, 0.7492570006072168, 0.003109412403643569, 
     1.] -> 0.65, 
   RGBColor[
    0.2960132375888991, 0.2960131125158366, 0.2960131444661215, 1.] ->
     0.8, RGBColor[
    0.6000193760698551, 0.8071089170241192, 0.998613272437677, 1.] -> 
    0.01, RGBColor[
    0.09982824341023538, 0.3304382676154282, 0.6514924833695483, 
     1.] -> 0.01, 
   RGBColor[
    0.6540282036622517, 0.6540488377301875, 0.6540691378617204, 1.] ->
     0.75};
anchorageCleanupRules = 
  MapThread[
   Rule, {Flatten@
     Nearest[Keys@anchorageCanonicalColorValueMap, 
      anchorageDominantColorsCity], anchorageDominantColorsCity}];
anchorageCityValueMap = 
  anchorageCanonicalColorValueMap /. anchorageCleanupRules;
anchorageCityColorCoverage = 
  DominantColors[anchorageGeo, 10, {"Color", "Coverage"}];
Transpose[anchorageCityColorCoverage /. anchorageCityValueMap];
anchorageCityWeightedByColor = 
  WeightedData @@ 
   Transpose[anchorageCityColorCoverage /. anchorageCityValueMap];

anchoragePermeability = Mean[anchorageCityWeightedByColor];

anchorageIntensity = 
  Mean[WeatherData[
     Entity["City", {"Anchorage", "Alaska", "UnitedStates"}], 
     "TotalPrecipitation", {{2000, 1, 1}, {2022, 12, 31}, "Year"}]]/
   2.54;

anchorageIntensityCalibrated = 
  Which[0 < anchorageIntensity < 5, 4.1 , 5 < anchorageIntensity < 10,
    4.2 , 10 < anchorageIntensity < 15, 4.3 , 
   15 < anchorageIntensity < 20, 4.4, 20 < anchorageIntensity < 25, 
   4.5 , 25 < anchorageIntensity < 30, 4.6 , 
   130 < anchorageIntensity < 35, 4.7 , 35 < anchorageIntensity < 40, 
   4.8 , 40 < anchorageIntensity < 45, 4.9 , 
   45 < anchorageIntensity < 50, 5.0 , 50 < anchorageIntensity < 55, 
   5.1 , 55 < anchorageIntensity < 60, 5.2 , 
   60 < anchorageIntensity < 65, 5.3 , 65 < anchorageIntensity < 70, 
   5.4 , 70 < anchorageIntensity < 75, 5.5 , 
   75 < anchorageIntensity < 80, 5.6 , 80 < anchorageIntensity < 85, 
   5.7 , 85 < anchorageIntensity < 90, 5.8 , 
   90 < anchorageIntensity < 95, 5.9 , 95 < anchorageIntensity < 100, 
   6.0];


anchorageAcres = 20^2*640;

anchoragePeakRunoff = 
  anchoragePermeability*anchorageIntensityCalibrated *anchorageAcres;

anchorageTotalRiverIncrease = (anchoragePeakRunoff/
     Part[Part[#, 2] & /@ 
       Select[DominantColors[
         GeoGraphics[
          GeoBoundingBox[
           Entity["City", {"Anchorage", "Alaska", "UnitedStates"}]], 
          GeoBackground -> "VectorMinimal", 
          GeoRange -> Quantity[20, "Miles"], GeoRangePadding -> None],
          5, {"Color", "Coverage"}], 
        ColorDistance[RGBColor[
           0.5998694708331431, 0.8076220271551392, 0.9996520209699861,
             1.], #[[1]]] < 0.1 &], 1])/11151360000*3600*2000

Out[284]= 1527.86
```
In the anchorageGeo model, we simulated 1527.86 feet of heavy rainfall over 2000 hours in Anchorage, Alaska. Then, we evaluated the ReliefPlot and ListPlot3D using the peakRunoff data we were able to determine using the rational method (Q = CiA). We now plot the Relief and 3D models.

<p align = "center" >

<img width="469" height = "469" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/b0b7cad3-c196-404d-9f04-7305f1d9ec26">
<img width="465"  height = "469" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/ac99c6e8-b978-4e0d-8110-b603e912029e">

</p>


## Tying Everything Together Part I

Just for fun, here is a model that ties together both aspects of our project.

```Mathematica
parisData = 
 GeoElevationData[Entity["City", {"Paris", "IleDeFrance", "France"}], 
  GeoRange -> Quantity[20, "Miles"], GeoProjection -> Automatic, 
  UnitSystem -> "Imperial"]

QuantityArray[{642, 640}, < Feet >]

```
![image](https://github.com/navvye/WaterGate/assets/25653940/ff212ded-d972-48c8-b1ae-c370bbcc9e49)
```Mathematica
In[37]:= {mi, ma} = QuantityMagnitude[MinMax[parisData]]

Out[37]= {43.2489, 719.016}
```

We create the Paris Relief Plot

```Mathematica
parisLevelPlot = 
 ColorReplace[
  ReliefPlot[parisData, PlotRange -> {mi + parisRiverIncrease, ma}], 
  White -> 
   Directive[RGBColor[0.6, 0.807843137254902`, 1.], Opacity[0.2]]]
```

<p align = "center" >
 <img width="467" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/e91fe0e1-1fd7-4900-877a-dab1dad1c193">

</p>

Now, we map the dimensions of Paris and print a Flood Plot

```Mathematica 

parisCityDimensions = 
 Dimensions[
  GeoElevationData[Entity["City", {"Paris", "IleDeFrance", "France"}],
    GeoRange -> Quantity[20, "Miles"]]]
    
parisFloodPlot = 
 Show[ListPlot3D[
   GeoElevationData[
    Entity["City", {"Paris", "IleDeFrance", "France"}], 
    GeoRange -> Quantity[20, "Miles"]], MeshFunctions -> {#3 &}, 
   PlotRange -> All, PlotStyle -> Texture[parisLevelPlot], 
   Filling -> Bottom, FillingStyle -> Opacity[1], ImageSize -> 1250, 
   Boxed -> False]]

```


 <p align = "center" >
  <img width="481" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/2878790f-7b80-4369-8d25-d383bdf10a94">

 </p>

 We create morphological graphs using our previous functionality 

 ```Mathematica
parisGraph = 
 Graph3D[MorphologicalGraph[
   Thinning[
    DeleteSmallComponents[
     Dilation[
      ColorNegate[
       Binarize[
        Graphics[
         Flatten[Cases[
           GeoGraphics[
            GeoBoundingBox[
             Entity["City", {"Paris", "IleDeFrance", "France"}]], 
            GeoBackground -> "VectorMinimal"], 
           water : {Directive[{___, 
                RGBColor[0.6, 0.807843137254902`, 1.], ___}], ___} :> 
            water[[2]], Infinity]]]]], 3]]]]]
```
<p align = "center" > <img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/52bdc63e-ee5e-4170-a4ef-4a863be0691d"> </p>

```Mathematica
elevationBoundingBox = 
 GeoBoundingBox[Entity["City", {"Paris", "IleDeFrance", "France"}]] //
   GeoBounds

{{48.86, 48.86}, {2.34, 2.34}}
```
Now, we map the vertices of the map onto the vertices we got using the elevation bounding box, and overlay on top of the

```Mathematica
parisElevated = 
 Graph3D[EdgeList[parisGraph], 
  VertexCoordinates -> 
   Rescale[Map[{#[[1]], #[[2]]} &, 
     VertexCoordinates /. 
      AbsoluteOptions[parisGraph, 
       VertexCoordinates]], {elevationBoundingBox[[1, 1]], 
     elevationBoundingBox[[2, 1]]}, {elevationBoundingBox[[1, 2]], 
     elevationBoundingBox[[2, 2]]}]]
```
<p align = "center"> <img width="779" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/c0459c66-56e0-47e4-9174-69d798dbfd11"> </p>


## 2D & 3D Population Density Model

Calculating population density can tell us how "at-risk" an area is at risk for flooding, hence an important metric to measure. While there are some built-in functions (GeoRegionValuePlot), the functional range is too limited and small.

Take this example from New York:

```Mathematica
GeoRegionValuePlot[
 EntityClass["AdministrativeDivision", "USCountiesNewYork"] -> 
  "Population"]
```
<p align = "center" > <img width="501" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/5f0f2ab3-82d3-4000-bd3d-6f091aa91f68"> </p>

To fix this, we simply used available population and landmass data to perform the population density calculation and project density through ListPlot3D. populationOverArea creates the ratio between the population and area of the specified area and textureDensity assigns the color based on the classifications of population density. Afterwards, we combine and overlay them using the same methods shown above.

Here is the population density map of New York City, New York using the variables populationOverArea, textureDensity, newYorkImage, riverImage, combinedNewYorkImage, and newYorkPopulation:

```Mathematica
populationOverArea = 
  Part[EntityValue[
     Entity["City", {"NewYork", "NewYork", "UnitedStates"}], 
     "Population"]/
    EntityValue[
     Entity["City", {"NewYork", "NewYork", "UnitedStates"}], "Area"], 
   1];

textureDensity = 
  Which[populationOverArea < 1000, Darker[Darker[Green]], 
   1000 < populationOverArea < 2000, Darker[Green], 
   3000 < populationOverArea < 4000, Green, 
   4000 < populationOverArea < 5000, Lighter[Green], 
   5000 < populationOverArea < 6000, Lighter[Lighter[Green]], 
   6000 < populationOverArea < 7000, Lighter[Lighter[Red]] , 
   7000 < populationOverArea < 8000, Lighter[Red], 
   8000 < populationOverArea < 9000, Red, 10000 < populationOverArea, 
   Darker[Red]];

newYorkImage = 
  GeoImage[Entity["City", {"NewYork", "NewYork", "UnitedStates"}], 
   GeoRange -> Quantity[10, "Miles"]];
riverImage = 
  ImageRecolor[
   Binarize[
    ColorNegate[
     GeoImage[Entity["City", {"NewYork", "NewYork", "UnitedStates"}], 
      "StreetMapNoLabels", 
      GeoRange -> Quantity[10, "Miles"]]]], {White -> 
     RGBColor[0, 0, Rational[2, 3], 0.5], 
    Black -> RGBColor[0.5, 0.5, 0.5, 0]}];
combinedNewYorkImage = ImageCompose[newYorkImage, riverImage];
newYorkPopulation = Blend[{combinedNewYorkImage, textureDensity}];
ListPlot3D[
 GeoElevationData[
  Entity["City", {"NewYork", "NewYork", "UnitedStates"}], 
  GeoRange -> Quantity[10, "Miles"]], MeshFunctions -> {#3 &}, 
 PlotRange -> All, 
 PlotStyle -> Texture[ImageRotate[newYorkPopulation, 3 Pi/2]], 
 Filling -> Bottom, FillingStyle -> Opacity[1], ImageSize -> 1000]
```

<p align = "center" > <img width="663" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/b513a01d-aa19-4042-92c7-d8b625e24533"> </p>

## Large Scale Modeling of River Width

We can model the river width of a certain river and its contributing tributaries through determining the length of notable bridges that cross the river from its origin to its delta. Specifically, we will use the functions FilteredEntityClass and GeoRegionValuePlot to create our river width weights.
Here is an example from the Missouri River
```Mathematica
missouriRiver = 
  EntityClass["River", 
    "Outflow" -> Entity["River", "MissouriRiver::72qm4"]] // 
   EntityList;
bridgeMissouri = 
  FilteredEntityClass["Bridge", 
    EntityFunction[
     x, ! MissingQ[x["Position"]] && 
      ContainsAny[x["Crosses"], 
       Append[missouriRiver, 
        Entity["River", "MissouriRiver::72qm4"]]]]] // EntityList;
GeoRegionValuePlot[
 EntityValue[bridgeMissouri, "Length", "EntityAssociation"], 
 AspectRatio -> 1, MissingStyle -> Transparent, 
 GeoBackground -> "Satellite"]
```

<p align = "center"> <img width="482" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/fd9fe5b2-26e4-4c81-8d16-11d44be6cbff"> </p>

A more comprehensive example that incorporates the river delta in relation with the origin is the Mississippi Rive, where we can see the gradual increase of river width as it moves towards the river delta. 
```Mathematica
mississippiRiver = 
 EntityClass["River", 
   "Outflow" -> Entity["River", "MississippiRiver::mnr4z"]] // 
  EntityList
bridgesMississippi = 
  FilteredEntityClass["Bridge", 
    EntityFunction[
     y, ! MissingQ[y["Position"]] && 
      ContainsAny[y["Crosses"], 
       Append[mississippiRiver, 
        Entity["River", "MississippiRiver::mnr4z"]]]]] // EntityList;
MississipiPlot = 
 GeoRegionValuePlot[
  EntityValue[bridgesMississippi, "Length", "EntityAssociation"], 
  AspectRatio -> 1, MissingStyle -> Transparent, 
  GeoBackground -> "Satellite"]
```

<p align = "center" > <img width="482" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/0593a0b3-c5c1-4dd6-8207-abce5e6d5e08">
</p>

## Using Bridges and Their Data

Getting tributaries for the famous Hudson River using the Outflow Functionality
```Mathematica
hudsonRiver = 
 EntityClass["River", "Outflow" -> Entity["River", "Hudson::ry5x6"]] //
   EntityList![image](https://github.com/navvye/WaterGate/assets/25653940/5485b4fc-88d7-42f9-9654-299cb0c2bf8b)
```

Creating a filtered entity class for those bridges that cross the hudson and it's tributaries and for which the position property is available

```Mathematica
bridgeHudson = 
 FilteredEntityClass["Bridge", 
   EntityFunction[
    x, ! MissingQ[x["Position"]] && 
     ContainsAny[x["Crosses"], 
      Append[hudsonRiver, Entity["River", "Hudson::ry5x6"]]]]] // 
  EntityList
```
<p align = "center"> <img width="635" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/81a55659-d117-46ab-b2e6-bc141c4cdb74"> </p>

Now we use the GeoRegionValuePlot on a Satellite Map 

```Mathematica
HudsonBridges = 
 GeoRegionValuePlot[
  EntityValue[bridgeHudson, "Length", "EntityAssociation"], 
  AspectRatio -> 1, MissingStyle -> Transparent, 
  GeoBackground -> "Satellite"]
```
<p align = "center" > <img width="482" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/afefa75e-ee1b-4058-a546-e0e5a19d7333">
</p>

We can show the Population of New York State and the length of bridges in meters on the same graph

<p align = "center" > <img width="554" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/d0c9da3c-2b33-4482-9d9b-1eb89063ee3b">
</p>

There seems to be some correlation between the population density of a place, and the length of the it's longest bridge (on the hudson river and it's tributaries). Now, we plot the graph of the Mississippi River with respect to the population  of states in the United States

```Mathematica
Show[{GeoRegionValuePlot[
 EntityClass["AdministrativeDivision", "USStatesAllStates" ] -> 
  "Population", ColorFunction -> "Rainbow", 
 GeoBackground -> "ReliefMap"], <img width="420" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/314491aa-8faf-4f9c-b52a-c1b0a5fa22c4">
}
```
<p align = "center" ><img width="630" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/4d0533cd-4a32-41ab-95f1-64b50d6a261e">
</p>


## Study of Bridges in Cities

### Bridge Density
We define the bridge density of a city to be the percentage of area covered by bridges to the percentage of area covered by water
```Mathematica
BridgePlot[city_] := 
 ImageResize[GeoListPlot[GeoEntities[SemanticInterpretation[city]
    , "Bridge"], GeoBackground -> "VectorMinimal"], 500];
ImageBridgePlot = ColorReplace[BridgePlot["New York State"], 
 FindMatchingColor[BridgePlot["New York State"], Red] -> Black]
```
<p align = "center" > <img width="365" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/3edb32f3-a8dd-4f75-a4a3-00e72da647f9">
</p>

```Mathematica 

ColorNegate[Binarize[%]]
levels = Last /@ ImageLevels[Image[%]]
N[Last[levels]*100/(First[levels] + Last[levels])]
```
Which returns 2.87407, implying that the percentage of area covered by Bridges in New York State is around 2.9%.

Now, we calculate the percentage of area covered by water in New York State

```Mathematica
riverNYC = 
 Graphics[
  Select[Cases[
    GeoGraphics[
     Entity["AdministrativeDivision", {"NewYork", "UnitedStates"}], 
     GeoBackground -> 
      "VectorMinimal"], {Directive[{___, 
       RGBColor[0.6, 0.807843137254902`, 1.], ___}], ___}, Infinity], 
   Not@*FreeQ[Polygon]]]
ColorNegate[Binarize[riverNYC]]
levels = Last /@ ImageLevels[Image[%]]
N[Last[levels]/(First[levels] + Last[levels])]
```
Hence, water covers approximately 18.3865% of New York. 

We can now combine the two observations using a ratio Function

```Mathematica
BridgeDensityNewYork = (2.87/18.3865)
Out[] = 0.183865
```

And of course, we can wrap this neatly in a function 

```Mathematica
BridgeDensity[place_] := 
 Module[{bridgePlotCity, bridgeImage, bridgeLevels, bridgeRatio, 
   riverCity, riverImage, riverLevels, riverRatio}, 
  bridgePlotCity = BridgePlot[place];
  bridgeImage = 
   ColorNegate[
    Binarize[
     ColorReplace[bridgePlotCity, 
      FindMatchingColor[bridgePlotCity, Red] -> Black]]];
  bridgeLevels = Last /@ ImageLevels[Image[bridgeImage]];
  bridgeRatio = 
   N[Last[bridgeLevels]*100/(First[bridgeLevels] + 
        Last[bridgeLevels])];
  riverCity = 
   Graphics[
    Select[Cases[
      GeoGraphics[SemanticInterpretation[place], 
       GeoBackground -> 
        "VectorMinimal"], {Directive[{___, 
         RGBColor[0.6, 0.807843137254902`, 1.], ___}], ___}, 
      Infinity], Not@*FreeQ[Polygon]]];
  riverImage = ColorNegate[Binarize[riverCity]];
  riverLevels = Last /@ ImageLevels[Image[riverImage]];
  riverRatio = 
   N[Last[riverLevels]/(First[riverLevels] + Last[riverLevels])];
  Return[bridgeRatio/riverRatio]]
```


## Using Dams and their Data 

Extracting Dams from Satellite Images 

```Mathematica
DamData[SemanticInterpretation["Tehri Dam"], "Position"]
GeoGraphics[GeoPosition[{30.377778`, 78.480556`}], 
 GeoBackground -> "VectorBusiness"]
```
<p align = "center" > 
 <img width="440" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/6220028f-1f74-4d22-90ad-05a940a13dca">
</p>

```Mathematica
geoImage = 
 DeleteSmallComponents[
  Dilation[
   Graphics[
    Select[Cases[
      GeoGraphics[
       GeoBoundingBox[GeoPosition[{30.377778`, 78.480556`}]], 
       GeoBackground -> 
        "VectorMinimal"], {Directive[{___, 
         RGBColor[0.6, 0.807843137254902`, 1.], ___}], ___}, 
      Infinity], Not@*FreeQ[Polygon]]], 0]]
```

<p align = "center" > <img width="291" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/6856885f-edbc-4215-a4c5-04ecd123c21f"> </p>

```Mathematica
ColorNegate[Binarize[geoImage]];
levels = Last /@ ImageLevels[Image[%]];
N[Last[levels]/(First[levels] + Last[levels])]

Out[] = 0.0244169
```
Hence, the Tehri covers approximately 2.44169% of the surrounding area.

### An Attempt to Compute the Volume & Area of Dam using Satellite Images

#### Finding Area 
```Mathematica
GeoGraphics[GeoRange -> {{36.05, 36.17}, {-98.7, -98.52}}, 
 GeoRangePadding -> Scaled[0.1], GeoBackground -> "Satellite"]
```
<p align = "center" > <img width="420" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/8f595024-62bd-4224-ae3b-ad7f6ecad746">
</p>

Creating a dam contour by manually using the Geo-Coordinates Tool
```Mathematica
damContour = {{36.14216500804076`, -98.66601000992658`}, \
{36.15131161335255`, -98.6549477815357`}, {36.1501032100147`, \
-98.62214348441108`}, {36.15000037203102`, -98.60908533742007`}, \
{36.13193732747872`, -98.58352140011719`}, {36.10128112030604`, \
-98.57004960135653`}, {36.08009879008038`, -98.6043835918035`}, \
{36.1172565230945`, -98.61315564049649`}, {36.12831708030723`, \
-98.62663775701455`}, {36.13202116684048`, -98.64507269213401`}, \
{36.13870030579935`, -98.6454368865287`}, {36.13708633726377`, \
-98.6568745786338`}};
GeoGraphics[{White, Thick, Line[GeoPosition[damContour]]}, 
 GeoRange -> {{36.05, 36.17}, {-98.7, -98.52}}, 
 GeoRangePadding -> Scaled[0.1], GeoBackground -> "Satellite"]
```
<p align = "center" > 
<img width="420" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/bf2d9a15-d0a2-4895-87bd-7a249ce39e1b">
</p>

```Mathematica
Ar = GeoArea[Polygon[GeoPosition[damContour]]]
Out[] = Quantity[27.6167, ("Kilometers")^2]
```
The area is relatively accurate.

Alternatively, we can also use the ImageMesh functionality — but this is only useful whilst comparing bridges from one to another.

The code has been provided here 

```Mathematica

DamExample = 
 Graphics[
  Select[Cases[
    GeoGraphics[GeoRange -> {{36.05, 36.17}, {-98.7, -98.52}}, 
     GeoRangePadding -> Scaled[0.1], 
     GeoBackground -> 
      "VectorMinimal"], {Directive[{___, 
       RGBColor[0.6, 0.807843137254902`, 1.], ___}], ___}, Infinity], 
   Not@*FreeQ[Polygon]]]

colorNegatedDamExample = ColorNegate[Binarize[DamExample]]

Area[ImageMesh[colorNegatedDamExample]]

Out[] = 16099
```

#### Finding Depth 
##### a) Using pure bathymetric functions

Use bathymetry to find the volume

```Mathematica
gcarc = GeoPath[Table[i, {i, damContour}], "Geodesic"];
gcarcDistance = 
  GeoDistance[Table[i, {i, damContour}], UnitSystem -> "Metric"];
profile = 
  GeoElevationData[gcarc, Automatic, "GeoPosition", GeoZoomLevel -> 4];
pts = profile[[1]][[1]];
depths = #[[3]] & /@ pts;
distances = 
  QuantityMagnitude[
     GeoDistance[{pts[[1]][[1 ;; 2]], #[[1 ;; 2]]}, 
      UnitSystem -> "Metric"]] & /@ pts;
avgDepth = UnitConvert[Quantity[Mean[depths], "Meters"], "Kilometers"]
```
##### b) Using Neural Networks

We use the Single-Image Depth Perception Net Trained on NYU Depth V2 and Depth in the Wild Data.

<p align = "center" > <img width="465" alt="Screenshot 2023-10-20 at 1 26 34 PM" src="https://github.com/navvye/WaterGate/assets/25653940/afe40fae-e04f-4432-bbb0-ce2adc2a73de">
</p>
<p align = "center" > <img width = "465" src = "https://github.com/navvye/WaterGate/assets/25653940/cfbf17f0-d596-4967-a342-0a8635ee9977"> </p>

```Mathematica

net = NetModel[
  "Single-Image Depth Perception Net Trained on NYU Depth V2 and \
Depth in the Wild Data"]
depthMap = net[Image[GeoGraphics[GeoRange -> {{36.05, 36.17}, {-98.7, -98.52}}, 
 GeoRangePadding -> Scaled[0.1], GeoBackground -> "Satellite"]]];
ListPlot3D[-Reverse@Normal@depthMap, ImageSize -> Medium]
```

<p align = "center">
<img width="394" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/59e83372-2105-4b0a-a983-b6bafbdab22a">

</p>

### Plotting Dams & Bridges on the same Map 

In this section, we create a bunch of helper-functions to perform operations on Dams using their properties

```Mathematica
DamData[Entity["Dam", "TehriDam::q2zsw"], "River"]
Out[] = {Entity["River", "Bhagirathi::wxk6g"]}
```
Create EntityClass of all the dams on a particular river

```Mathematica
DamsOn[River_] := 
 EntityClass["Dam", "River" -> SemanticInterpretation[River]] // 
  EntityList

DamsOn["Bhagirathi River"]
Out[] = {Entity["Dam", "ManeriDam::t599k"], 
 Entity["Dam", "LoharinagPalaHydroPowerProject::x3gz9"], 
 Entity["Dam", "TehriDam::q2zsw"]}
```

Get the position of all the Dams 

```Mathematica

PositionDams[River_] := 
 Table[DamData[i, "Position"], {i, 
   EntityClass["Dam", "River" -> SemanticInterpretation[River]] // 
    EntityList}]
```

Position for the Ganges River

```Mathematica

PositionDams["Ganges River"]

Out[] = {GeoPosition[{24.8044, 87.9331}], GeoPosition[{26.5099, 80.3186}], 
 GeoPosition[{30.0742, 78.2883}]}
```

Get Images of Dams on a particular River

```Mathematica

ImagesOnPositionDams[River_] := 
 Table[DamData[i, "Image"], {i, 
   EntityClass["Dam", "River" -> SemanticInterpretation[River]] // 
    EntityList}]
ImagesOnPositionDams["Ganges River"]
```

```Mathematica

AssortDamsOn[River_] := 
 ReverseSortBy[
  Table[{i, DamData[i, "HighestPoint"]}, {i, DamsOn[River]}], Last]
AssortDamsOn["Ganges River"]

Out[] = {{Entity["Dam", "FarakkaBarrage::6s3m8"], 
  Quantity[2240., "Meters"]}, {Entity["Dam", 
   "LavKhushBarrage::xptn2"], 
  Quantity[621., "Meters"]}, {Entity["Dam", "PashulokBarrage::794pd"],
   Quantity[320., "Meters"]}}
```

## Tying Everything Together Part II 

Create an entity class of all the tributaries of the Mississippi river

```Mathematica

mississippiRiver = 
  EntityClass["River", 
    "Outflow" -> Entity["River", "MississippiRiver::mnr4z"]] // 
   EntityList;
DamsMississippi = 
  FilteredEntityClass["Dam", 
    EntityFunction[
     y, ! MissingQ[y["Position"]] && 
      ContainsAny[y["River"], 
       Append[mississippiRiver, 
        Entity["River", "MississippiRiver::mnr4z"]]]]] // EntityList;
MississipiPlotDams = 
 GeoRegionValuePlot[
  EntityValue[DamsMississippi, "Length", "EntityAssociation"], 
  AspectRatio -> 1, MissingStyle -> Transparent, 
  GeoBackground -> "Satellite", ColorFunction -> "Rainbow"]
```

<p align = "center"> 
<img width="503" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/aa6137b1-6e0d-45a2-a070-ecfca699b117">
</p>

This shows a positive correlation between the location of tall dams and long bridges.

## Creating Stream Order from Tree Graphs 

The Strahler number or Horton\[Dash]Strahler number of a mathematical tree is a numerical measure of its branching complexity.

<p align = "center">
<img width="700" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/a9038702-91c4-44f0-a3ab-f5564557232c">

</p>

The Algorithm for implementing the Strahler Stream Order is 
1) If the node is a leaf (has no children), its Strahler number is one.
2) If the node has one child with Strahler number i, and all other children have Strahler numbers less than i, then the Strahler number of the node is i again.
3) If the node has two or more children with Strahler number i, and no children with greater number, then the Strahler number of the node is i + 1.

We use the IGraph module.
```Mathematica

Needs["IGraphM`"]
<< IGraphM`;

```

```Mathematica
IGVertexMap[# &, VertexLabels -> IGStrahlerNumber, %]
```

## Statistical Analysis

Statistical Analysis Code

```Mathematica

levels = 
  Select[Drop[ExampleData[{"Statistics", "LakeMeadLevels"}], None, 
     1] // Flatten, Positive];
maxLevel = 1229;
relativeLevels = levels/maxLevel;
edist = EstimatedDistribution[relativeLevels, 
  KumaraswamyDistribution[\[Alpha], \[Beta]]]
Out[] = KumaraswamyDistribution[30.543, 2.7868]

```

```Mathematica

Show[Histogram[relativeLevels, Automatic, "PDF"], 
 Plot[PDF[edist, x], {x, 0.7, 1.1}, PlotStyle -> Thick]]
```

<p align = "center"> 
<img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/e1623154-e2a4-4d84-8c0b-c436b6281d25">
</p>

```Mathematica

drought = 1125;
Probability[x*maxLevel < drought, x \[Distributed] edist]*100
N[Probability[x*maxLevel < drought, x \[Distributed] edist]]*100
maxLevel Mean[edist]
Out[] = 1160.59
```

```Mathematica
ListPlot[{maxLevel RandomVariate[edist, 36], {{0, drought}, {36, 
    drought}}}, Filling -> {1 -> Axis}, Joined -> {True, True}]

```
<p align = 'center' > 
<img width="706" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/add3c966-b4ec-4683-a7fb-7ba490c7a6e6">
</p>


```Mathematica

data = ExampleData[{"Statistics", "MahanadiRiverFlow"}]
mean = Mean[data];
data0 = data - mean;
eproc = EstimatedProcess[data0, FARIMAProcess[4, 3]]
Out[] = EstimatedProcess[{0.415455, 0.105455, -0.724545, 
  1.54545, -0.414545, -0.754545, 0.355455, 
  1.11545, -1.51455, -0.0745455, -0.644545, 0.0454545, -0.524545, 
  0.155455, 2.08545, -0.434545, 2.95545, 
  0.185455, -1.00455, -0.894545, -1.34455, -0.634545}, 
 FARIMAProcess[4, 3]]
```

## Using Real Time Satellite Imagery to Calculate Change in Water Levels 

### Introduction to OpenWeatherMap 
OpenWeatherMap is an online service, owned by OpenWeather Ltd, that provides global weather data via API, including current weather data, forecasts and historical weather data for any geographical location.
Based on a large amount of processing satellite and climate data, it provides satellite imagery, vegetation indices and weather data as well as analytical reports and crop monitoring.

<p align = 'center' > 
<img width="730" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/f88a77d8-4ac6-4526-b43f-a9619e6d7aab">
</p>

### Explaining the API Process
The OpenWeatherMap API uses Polygons to store a unit of Area. We can create polygons either using a POST method, or by manually drawing them onto a map.  

#### Creating a Polygon using GeoJSON Coordinates

<p align = "center"> 
<img width="317" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/645fc69f-99e1-45f8-ae7d-2c0f19b60066">
</p>


```Mathematica
apiKey = "3b45dd32459f1d1d846105e225d9cd5c";
url = "http://api.agromonitoring.com/agro/1.0/polygons?appid=" <> 
   apiKey <> "&duplicated=true";
headers = <|"Content-Type" -> "application/json"|>;
payload = <|"name" -> "Test", 
   "geo_json" -> <|"type" -> "Feature", "properties" -> <||>, 
     "geometry" -> <|"type" -> "Polygon", 
       "coordinates" -> {{{-122.26514, 38.673462}, {-122.232127, 
           38.624054}, {-122.267076, 38.6017}, {-122.298185, 
           38.633546}, {-122.26514, 38.673462}}}|>|>|>;
Out[] = <|"name" -> "Test", 
 "geo_json" -> <|"type" -> "Feature", "properties" -> <||>, 
   "geometry" -> <|"type" -> "Polygon", 
     "coordinates" -> {{{-122.265, 38.6735}, {-122.232, 
         38.6241}, {-122.267, 38.6017}, {-122.298, 
         38.6335}, {-122.265, 38.6735}}}|>|>|>
```

Execute the POST Request

```Mathematica
response = 
 URLExecute[
  HTTPRequest[
   url, <|"Method" -> "POST", "Headers" -> headers, 
    "Body" -> ExportString[payload, "RawJSON"]|>]]

Out[] = {"id" -> "65203ca293997d62b1bfbdce", 
 "geo_json" -> {"type" -> "Feature", "properties" -> {}, 
   "geometry" -> {"type" -> "Polygon", 
     "coordinates" -> {{{-122.265, 38.6735}, {-122.298, 
         38.6335}, {-122.267, 38.6017}, {-122.232, 
         38.6241}, {-122.265, 38.6735}}}}}, "name" -> "Test", 
 "center" -> {-122.266, 38.6332}, "area" -> 2303.17, 
 "user_id" -> "6519d9be86ec340008b8af3c", "created_at" -> 1696611490}
```

Now, we can verify that the polygon has been created:

```Mathematica

viewURL = 
 Last[Import[
   "http://api.agromonitoring.com/agro/1.0/polygons?appid=" <> 
    apiKey]]

Out[] = {"id" -> "65203ca293997d62b1bfbdce", 
 "geo_json" -> {"type" -> "Feature", "properties" -> {}, 
   "geometry" -> {"type" -> "Polygon", 
     "coordinates" -> {{{-122.265, 38.6735}, {-122.298, 
         38.6335}, {-122.267, 38.6017}, {-122.232, 
         38.6241}, {-122.265, 38.6735}}}}}, "name" -> "Test", 
 "center" -> {-122.266, 38.6332}, "area" -> 2303.17, 
 "user_id" -> "6519d9be86ec340008b8af3c", "created_at" -> 1696611490}
```
Importing & Visualizing Data

Importing the Data using the API is a two step process. We must first call the polygons ID API, and then use that to get Satellite, NDVI and other data in the JSON format. After that, we can process the data and look at some applications 

```Mathematica

urlToFetch = 
 Import["https://api.agromonitoring.com/agro/1.0/image/search?start=\
1646245800&end=1646850600&polyid=651f1602287b0e3c2bfcebe8&appid=\
3b45dd32459f1d1d846105e225d9cd5c"]
```

Let's break down the URL
1) image - to get the image data values 
2) start  = EPOCH Time Start Value
3) end = EPOCH Time End Value 
4) polyID = PolygonID - can be found easily by visiting the website, or by looking at the metadata if you created the polygon using an API Request
5) appID = APIKEY

```Mathematica
Map[Import, Flatten[Table[
  Values[Values[urlToFetch[[i]][[6]]]], {i, Length[urlToFetch]}]]]
```

<p align = "center">
<img width="635" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/453b4076-51b9-427b-b9f9-4f096c2f31c9">
</p>


```Mathematica
Import["https://api.agromonitoring.com/agro/1.0/image/search?start=\
1646245800&end=1646850600&polyid=651eb60393997d383cbfbdb9&appid=\
3b45dd32459f1d1d846105e225d9cd5c"];
Flatten[Table[Values[Values[%[[i]][[6]]]], {i, Length@%}]]
```

<p align = "center">
<img width="635" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/906d7f83-870b-41ee-97a9-0f496a45d043">
</p>

### Calculating Change in Water Levels

We choose the satellite images of blue color  

<p align = "center">

<img width="266" alt="Screenshot 2023-10-20 at 2 33 06 PM" src="https://github.com/navvye/WaterGate/assets/25653940/a07f687c-7558-4207-ac99-a97bce3f9748">
</p>

The images are not the same, hence we know that there has been a change in the water levels

```Mathematica

imgBinarize1 = Binarize[ColorNegate@Image[img1]]
imgBinarize2 = Binarize[ColorNegate@Image[img2]]
```

<p align = "center"> 
<img width="291" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/9d17a383-6a37-48e2-9f0e-723af3134b90">
 <img width="284" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/e73b0c33-f59f-4015-b6a7-f279f397ad3b">
</p>

Find the Image Histogram of the two binary levels in the image.
```Mathematica
ImageHistogram/@{imgBinarize1, imgBinarize2}
````
<p align = "center">
<img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/343662c7-57cf-4b90-b80b-9278bc96d18a">
<img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/0f207592-e429-4efd-820b-f8de13541810">

</p>

The graphs appear similar, indicating that not a lot of change has taken place in the time period. We can find the change in the area 

```Mathematica
Last/@ImageLevels[imgBinarize1]
Out[] = {32038, 62138}
Ratio1 = 100*N[Last[%]/(Last[%] + First[%])]
Out[] = 65.9807
```
Hence, Around 65.9807% of the region is covered by water in Image1
```Mathematica

Last/@ImageLevels[imgBinarize2]
Out[] = {32085, 62091}
Ratio2 = 100*N[Last[%]/(Last[%] + First[%])]
Out[] = 65.9308
```
Around 65.9308% of the region is covered by water in Image1.

Now, we can calculate the difference in water percentage
```Mathematica
DifferenceInWaterLevels = (Ratio1 - Ratio2)
Out[] = 0.0499066
```
Result = 0.0499066


## Watershed Delineation 

Watershed delineation refers to the process of identifying the boundary of a water-basin, drainage basin or
catchment. It is an extremely important process in the fields of environment science and hydrology.We start by taking
the Magnitude of the elevation of Sundarbans National Park, a famous delta basin system in India and Bangladesh.
Then, we use the ReliefPlot functionality to generate a relief plot from the array of height values.

```Mathematica
data = N[
   QuantityMagnitude[
    GeoElevationData[
     Entity["Park", "SundarbansNationalParkOfIndia::vr2b8"]]]];
reliefmap = 
 ReliefPlot[data, DataReversed -> True, 
  PlotLegends -> BarLegend[Automatic, LegendLabel -> "elevation(m)"]]
```
<p align = "center">
<img width="446" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/0ed7bc16-4bdb-45af-884e-e57ca22a1dbf">
</p>
Next, we create an image using the array of geo-elevation values, and use the ImageAdjust function - which adjusts
the levels in image, rescaling them to account for bad lighting.

```Mathematica 
mimg = ImageAdjust@Image[data]
```

<p align = "center">
<img width="470" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/0d317ca0-4fdb-44a1-bc6d-057e48e8d589">
</p>

```Mathematica
wsc = WatershedComponents[mimg, Method -> "Immersion"];
````
The watershed components functionality returns the transform of an image, computes the watershed transform of
image, and returns the result as an array in which positive integers label the catchment basins. We then create an image
on the basis of the watershed components, and then apply color negate to the image to create a binary image. This
allows us to clearly see the de-segmentation of the basis into sub-basins, which is very useful.

```Mathematica

bnds = ColorNegate@Image[wsc, "Bit"]
```

<p align = "center"> 
<img width="470" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/43c9f68c-67a9-4e38-a398-2c82c7caa515">
</p>


Next, we apply functions such as Erosion and Dilation to obtain data about the image, and then create an association
thread between the two datasets. We then create a function to evaluate the components of the image that are minimum
and at the border of the image, and weed them out. 

```Mathematica
bindex = Erosion[Replace[wsc, 0 -> Max[wsc] + 1, {2}], 1]
tindex = Dilation[wsc, 1]

doubleIndexArray = 
 Replace[Transpose[{bindex, tindex}, {3, 1, 2}], {n_, n_} -> {0, 
    0}, {2}]
{data, mimg, wsc, bnds, bindex, tindex, doubleIndexArray, 
   doubleIndexPairs, bndSegs, MinATborders, g0, g1, 
   basinConnect} = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
funcDelineate[region_] := Module[{}, 
  data = 
   N[QuantityMagnitude[
     GeoElevationData[SemanticInterpretation[region]]]];
  mimg = ImageAdjust@Image[data];
  wsc = WatershedComponents[mimg, Method -> "Immersion"];
  bnds = ColorNegate@Image[wsc, "Bit"];
  bindex = Erosion[Replace[wsc, 0 -> Max[wsc] + 1, {2}], 1];
  tindex = Dilation[wsc, 1];
  doubleIndexArray = 
   Replace[Transpose[{bindex, tindex}, {3, 1, 2}], {n_, n_} -> {0, 
      0}, {2}];
  doubleIndexPairs = 
   Prepend[DeleteCases[
     DeleteDuplicates[Flatten[doubleIndexArray, 1]], {0, 0}], {0, 
     0}];
  bndSegs = 
   Replace[doubleIndexArray, 
    Dispatch@MapIndexed[#1 -> First[#2] - 1 &, doubleIndexPairs], {2}];
  MinATborders = 
   Thread[Rest[doubleIndexPairs] -> 
     ComponentMeasurements[{mimg, bndSegs}, "Min"][[All, 2]]];
  g0 = Graph[Apply[UndirectedEdge, Rest@doubleIndexPairs, {1}]];
  g1 = WeaklyConnectedGraphComponents[g0][[1]];
  basinConnect = 
   Sort[Map[# -> AdjacencyList[g1, #] &, VertexList[g1]]];
  
  Print[GraphPlot3D@g1]
  ]
```

The interaction between various basin components, such as how water flows between them, is known as the hydrological connectedness of a river basin. A graph can be used to illustrate this connectivity, with each vertex representing a section of the basin and the edges denoting the links among them.
In this context, clusters are collections of linked vertices that constitute functional units in the hydrographical ecology
of the river basin. These groups represent bigger river basins or regions within it that have comparable hydrological

Below is the watershed delineation for the SunderBans River before and after applying the Transitive Reduction Graph Functionality 
<p align = "center"> 
<img width="400" height = "400" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/88c22786-aad4-4862-a808-6ef32cec181e">
<img width="400" height = "400" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/c54f42b8-8a76-48c2-9d68-6c1da50cb354">

</p>

Furthermore, we can use the KCoreComponent functionality and highlight the important subgraphs in a complex graph system. These
watershed-delineations are way more accurate compared to the first one. Another way to do this is to label the boundary
between two adjacent sub-basins by the indexes of corresponding sub-basins and then gauge at how the vertices are
connected together and what are the corresponding clusters made out of connected vertices. This would mean that
clusters represent larger basins that form a unique hydro-graphical ecosystem with a unique water graph.
<p align = "center">
 <img width="400" height = "400" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/f514cdc2-fc38-4a7a-a189-07fe092413a6">
<img width="400" height = "400" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/7960ea0d-2f3b-4cfd-90a4-4bb1ef0729f8">
</p>

## Using cellular automata 

### Introduction 

Flooding in urban areas may cause severe damage to infrastructure and uproot communities. Cities by the ocean also regularly face coastal flooding. Accurate modeling of water flow is crucial for various applications, such as urban planning, flood prediction, and water resource management. With increased flood rates around the world, we decided to create a flood inundation model.	In this section, we model water runoff using two different approaches: a bathtub inundation model and a cellular automata model.  We want to visualize regions that will get the most water during heavy rainfall. The model assumes uniform rainfall, and hydrological losses are not considered. By incorporating the bathtub model into our framework, we ensure that water is distributed uniformly over the simulated area, facilitating an initial estimation of water accumulation and infiltration. Using a weighted cellular automata model enables a more realistic representation of water flow dynamics, accounting for the physical limitations on water velocity through the use Manning's formula and the critical flow equation. 

#### Locations

We ran the model over the following locations: 

1) Atlantic City, NJ
2)Delaware River(PA & NJ)
3)Princeton, NJ

### Elevation Bathtub Model

To start, we used the simple bathtub inundation model to display the purpose of the project, which is to show where water will food when the water level is raised. The model assumes that the areas will be inundated if their elevation is below the projected water level.

#### Atlantic City
Atlantic City is a coastal resort city in New Jersey, know for its many casinos, wide beaches, and Boardwalk. It is frequently flooded by the Atlantic Ocean, especially with the ocean rising at faster rates in the future. 

We access Wolfram' s GeoElevationData for Atlantic City, that is stored in a 2 D Quantity Array :
```Mathematica
data = GeoElevationData[
   Entity["City", {"AtlanticCity", "NewJersey", "UnitedStates"}], 
   GeoRange -> Quantity[5, "Kilometers"], GeoProjection -> Automatic];![image](https://github.com/navvye/WaterGate/assets/25653940/1b0b0b58-125d-49ce-8e77-74fac51677eb)
```

Here, we created a visualization that allows you to manipulate the sea level to observe which regions will be flooded. We used the Manipulate, ListPlot3D to plot the GeoElevationData, and used ColorFunction to set regions below sea level to blue.

```Mathematica
Manipulate[
 ListPlot3D[Reverse[data], MeshFunctions -> {# &}, Mesh -> 30, 
  ImageSize -> Medium, 
  ColorFunction -> 
   Function[{x, y, z}, 
    If[z <= sealevel, ColorData["DeepSeaColors"][0.1 z + 2], 
     RGBColor["#a38672"]]], ColorFunctionScaling -> False], {sealevel,
   0, 10}, SaveDefinitions -> True]
```

<p align = "center"> 

<img width="404" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/9c327d16-f0d1-4283-9e3d-a6530ff78ec7">
</p>

We can also visualize this in 2D, using a ReliefPlot.

```Mathematica
Manipulate[
 ReliefPlot[data, 
  ColorFunction -> 
   Function[{x}, 
    If[x <= sealevel, ColorData["DeepSeaColors"][0.1 x + 2], 
     ColorData["SandyTerrain"][0.1 x]]], 
  ColorFunctionScaling -> False, 
  PlotLegends -> 
   Placed[BarLegend[Automatic, LegendLabel -> "Elevation"], {After, 
     Top}]], {sealevel, 0, 10}, SaveDefinitions -> True]
```
<p align = "center"> 
<img width="472" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/b6658e32-d212-4793-9e1e-8aa1e4f9a22b">
</p>

#### Delaware River

We will also apply the bathtub model to the Delaware River in the East Coast of the US. 

We generate a list of coordinates based on the part of the Delaware River we want to focus. I will focus on the Pennsylvania-New Jersey section, stretching from New Hope, PA, to Hopewell, NJ:

```Mathematica
DEcoords = 
  Table[{x, y}, {x, 40.188083, 
    40.353025, .001}, {y, -74.959693, -74.730801}];
```

Then, I get the GeoPosition at the coordinates so I can use GeoElevationData on my coordinates.

```Mathematica
DEdata = GeoElevationData[GeoPosition /@ Flatten[DEcoords, 1]];
```

We'll visualize this again in 3D and 2D.

```Mathematica
Manipulate[
 ListPlot3D[Reverse[DEdata], MeshFunctions -> {# &}, Mesh -> 30, 
  ImageSize -> Medium, 
  ColorFunction -> 
   Function[{x, y, z}, 
    If[z <= sealevel, ColorData["DeepSeaColors"][0.01 z], 
     ColorData["SandyTerrain"][0.001 z + 0.6]]], 
  ColorFunctionScaling -> False, PlotLegends -> Automatic], {sealevel,
   50, 600, 10}, SaveDefinitions -> True]
```

<p align = "center"> 

<img width="404" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/e82fe623-c9bd-42fd-a655-8dee4cb481c3">
</p>

Using ReliefPlots

```Mathematica
Manipulate[
 ReliefPlot[DEdata, 
  ColorFunction -> 
   Function[{x}, 
    If[x <= sealevel, ColorData["DeepSeaColors"][0.01 x], 
     ColorData["SandyTerrain"][0.001 x + 0.6]]], 
  ColorFunctionScaling -> False, 
  PlotLegends -> 
   Placed[BarLegend[Automatic, LegendLabel -> "Elevation"], {After, 
     Top}]], {sealevel, 50, 600, 10}, SaveDefinitions -> True]
```

<p align = "center">

 <img width = "404" height = "404" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/ae0c86cf-ec69-4f99-8ecf-663922b1c78f">
</p>

But, water flow has many other factors than just elevation and wouldn't just go where the lowest elevation. While the bathtub model captures the the general idea of where water will travel, our cellular automata model will consider more factors of how water flows and more accurately predict  water spread. 

### Cellular Automata Overview

We used a Cellular Automata(CA) approach to simulate flooding across a region due to heavy rainfall (pluvial flooding) in 2D. Cellular automata are discrete models that simulate the behavior of individual cells based on predefined rules. The model divides the area of land into a discrete space of square grid cells. We will take the Von Neumann neighborhood for each cell, meaning a central cell has 4 neighbor cells adjacent to it. Water flows from the central cell to neighboring cells depending on the water flow rules that the model will set.

<p align = "center">
<img width="186" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/44f2068f-42eb-4379-b9e1-40b192db9b61">
</p>

And also 

<p align = "center"> 
<img width="352" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/a88a028f-1d74-4303-81b9-15f7e58e660c">
</p>
Each point in this graph represents one cell of water, whose volume will depend on the size of our dataset. 

```Mathematica
graph=GridGraph[{7,7}]
```
<p align ="center">
<img width="192" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/2f032b64-fd69-4124-95e5-bda2a7ebd6e8">
</p>

For example, consider vertex 9.  NeighborhoodGraph will show the 4 neighbors of vertex 9. Here, vertex 9 is colored red.

```Mathematica
NeighborhoodGraph[GridGraph[{7,7},VertexStyle->{9->Red}],9]
```
<p align = "center">
<img width="197" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/98bb3952-d381-4b05-966f-801d2d0fb872">
</p>

### Simple Cellular Automata Model

#### Rule
The guiding transition rule of this model is for a central cell to give its neighboring cells 1 unit of water depth if it has a higher water level than its neighbor. Then, I apply this rule to every cell in the grid, iterating until the water depths are relatively constant.

Note that center cells will only give away water, and neighbor cells will only receive water. 

So, upstream cells (higher water level than center) aren't changed, and downstream cells will get water. 

#### Data 

```Mathematica
smelevdata = 
  GeoElevationData[
   Entity["City", {"AtlanticCity", "NewJersey", "UnitedStates"}], 
   GeoRange -> Quantity[100, "Meters"], GeoProjection -> Automatic];
smelevdata = Flatten[QuantityMagnitude[Normal@smelevdata]];
```

We will have two versions of this model: one that updates each cell one by one, which is not as accurate since water doesn't flow from one cell, rather all at once since it is coming from above, and one that updates the cells simultaneously. The first model helps us visualize what is actually going on at every step.

#### Step By Step Model

###### Helper Functions:

We define two helper functions for the rule: add, which adds one to the value at waterdepths, and subtract, which subtracts one. 
```Mathematica
add1[i_] := ReplacePart[waterdepths, i -> waterdepths[[i]] + 1];
subtract1[i_] := ReplacePart[waterdepths, i -> waterdepths[[i]] - 1];
```
###### Rule Function
Here is the rule for the first simple model we will make. 

The rule goes through each neighbor cell of the center cell, which is passed as a parameter. Each neighbor cell is updated based on a water level comparison to the center cell. Note the center cell will not give water if it is less than 1, otherwise its water depth will be negative, which is not possible.

```Mathematica

smrule1[center_] := Table[
  If[
   smelevdata[[center]] + waterdepths[[center]] > 
    smelevdata[[x]] + waterdepths[[x]], 
   If[waterdepths[[center]] >= 1,
    waterdepths = add1[x]; waterdepths = subtract1[center];]
   ],
  {x, neighbors[center]}
  ]
```

##### Visualization
We will plot the new waterdepths and elevation using BarChart3D. We stack the waterdepth over the elevation, to see what water will look like on the land we took. waterdepths is set to 5 at cell, representative of the amount of uniform rainfall. And of course, before running the model, we reset the values of waterdepths. 


```Mathematica
waterdepths = Table[5, 49];

style = {ChartLayout -> "Grid", Method -> {"Canvas" -> False}, 
   BarSpacing -> {.1, .1}};
```

To do this, we use ListAnimate and iterate through every step . One iteration is when every cell becomes the center cell once; it goes from 1 to 49, updating the waterdepths values each time . This allows us to see what it going on at each step .

```Mathematica

ListAnimate[
 First /@ 
  Table[{Show[
     BarChart3D[Partition[smelevdata, 7], style, 
      ColorFunction -> "SiennaTones", 
      ChartElementFunction -> 
       Function[{xyz, z}, {Cuboid @@ Transpose@xyz}]], 
     BarChart3D[Partition[waterdepths + smelevdata, 7], style, 
      ColorFunction -> "DeepSeaColors", 
      ChartElementFunction -> 
       Function[{xyz, z}, {Opacity[.5], 
         Cuboid @@ Transpose@(0.0015223 + 0.999123 xyz)}]], 
     ImageSize -> Large],
    smrule1[#] & /@ Range[49];}, {x, 1, 10}], SaveDefinitions -> True]
```
<p align = "center"> <img width="430" alt="Screenshot 2023-10-20 at 5 52 26 PM" src="https://github.com/navvye/WaterGate/assets/25653940/22c3fdb8-f18e-4a8c-b83f-c2db00152d3f"> 
</p>

### Weighted Cellular Automata Model

Now, we will use a more complex cellular automata model to display the water flow. This model, called WCA2D, Weighted Cellular Automata 2D, uses a weight computing system and physical limitations to model water flow without too complex mathematical equations and fluid dynamics concepts (Guidolin et al., 2016).In the model, the ratios of water are transferred from the central cell to the downstream neighbor cells using a weight-based system. The water transferred will be limited by Manning's formula and the critical flow equation, to produce a more accurate prediction of resulting water levels. 
#### Data
```Mathematica
elevationdata = 
  GeoElevationData[
   Entity["City", {"AtlanticCity", "NewJersey", "UnitedStates"}], 
   GeoRange -> Quantity[100, "Meters"], GeoProjection -> Automatic];
elevationdata = Flatten[QuantityMagnitude[Normal@elevationdata]]
elevationdata = elevationdata - Min[elevationdata];
```
Each coordinate point, with a corresponding elevation, constitutes a cell:

```Mathematica
graph = GridGraph[{7, 7}];
```

The area of a cell is defined by the area of region/number of cells. The edge is the sqrt of the area. 
A small tolerance to set to help reduce oscillation. Downstream cells whose water levels are within tolerance of the center cell will be ignored, and won't receive water.

```Mathematica
area=100/Length[elevationdata];
edgelength=Sqrt[area];
tolerance = 0.1;
```

Now, we set the initial waterdepth to 5 at every cell(e.g. 5 in of rainfall)

```Mathematica
waterdepth = Table[5, 49];
```

#### Steps

To distribute the volume being transferred from the central cell to the neighborhood,  we use a weighting system. 
1) Identify downstream cells
2) Compute weights based on available storage volume
3) Compute total volume leaving central cell
4) For each downstream cell, calculate the new intercellular-volume

We use the following helper functions to accomplish this:
##### Identifying Downstream Cells

Finds the difference in water level(elevation+waterdepth) between center and ith neighbor:
```Mathematica
waterleveldiff[center_, 
  i_] := (elevationdata[[center]] + 
    waterdepth[[center]]) - (elevationdata[[i]] + waterdepth[[i]])
```
Available storage volume is the possible volume a neighbor cell can store from the center cell. Note that this value will be 0 for upstream cells since neighbor cells never give water. It is the water level difference, which is in m, multiplied by area (m^2).

Note that if there are no eligible cells to receive water(either upstream or doesn't satisfy tolerance), this value is set to 0.

The following code 
Finds available storage volume of the ith neighbor cell of center and determines whether a center cells has downstream cells.

```Mathematica

availstoragevol[center_,i_]:=Max[waterleveldiff[center,i],0]*area
upstream[center_]:=If[Select[neighbors[center],waterleveldiff[center,#]>tolerance&]=={},True,False]
```


#### Weight Computing

We define the following Helper Functions

Minstorage volume Finds the minimum available storage volume between all the neighbor cells of a center cell:
MaxStorage volume Finds the maximum available storage volume(used later but not in weights):
Mcell Finds the index of the cell with maximum available storage volume:
TotStorageVolume Finds the total volume that all the neighbor cells can receive from the center cell:

```Mathematica
minstoragevol[center_]:=area*With[{list=Select[waterleveldiff[center,#]
	&/@neighbors[center],#>tolerance&]},
	If[list=={},0,Min[list]]]

maxstoragevol[center_]:=area*With[{list=Select[waterleveldiff[center,#]
	&/@neighbors[center],#>tolerance&]},
	If[list=={},0,Max[list]]]

Mcell[center_]:=neighbors[center][[Position[availstoragevol[center,#]&/@neighbors[center],maxstoragevol[center]][[1,1]]]]
totstoragevol[center_]:=Total[availstoragevol[center,#]&/@neighbors[center]]
```
We use these functions to compute weights for the neighborhood, using the following equation:

The weight of a downstream cell is the ratio between its available storage volume and the total available storage volume, representing a fraction of the volume that the center cell will give away. To reduce oscillations, we allow the center cell to retain a fraction of the volume transferred, giving it the same weight as the minimum storage volume. The weights should always add to 1.
```Mathematica
weight[center_,i_]:=availstoragevol[center,i]/(totstoragevol[center]+minstoragevol[center])
weight[center_] := minstoragevol[center]/(minstoragevol[center]+totstoragevol[center])
```
#### Total Intercellular-Volume

The total intercellular-volume is the volume of water that leaves the center cell. Note that it is different from the total available storage volume previous calculated. 

This value is calculated by taking the minimum of three values. 

In the first term, the total intercellular-volume is limited by the amount of water that exists in the center cell.

In the second term, we use Manning's formula and the critical flow equation that imposes a physically based equation. This dictates the maximum permissible velocity of water.

In the third term, the total intercellular-volume is limited by the minimum available storage volume  + the total intercellular-volume that left the cell in the previous time step to reduce oscillations.

##### Helper Functions
**Second Term:**

Finds the limiting velocity using the critical flow equation:
```Mathematica
vcrt[center_] :=If[waterdepth[[center]]<=0,Sqrt[waterdepth[[center]]*9.8],Sqrt[waterdepth[[center]]*9.8]]
```

Finds the limiting velocity using Manning's formula. 
```Mathematica
vman[center_]:=Power[waterdepth[[center]],(2/3)]*Sqrt[waterleveldiff[center,Mcell[center]]/edgelength]
```
Finds limiting volume based on the minimum of the two limiting velocities:

```Mathematica
maxicvol[center_]:=Min[vcrt[center],vman[center]]*waterdepth[[center]]*edgelength
```

**Third Term**

To find the total intercellular-volume(Itot) from the previous iteration, we store the values in a new list called Itots. 

```Mathematica
Itots = Table[Table[0, 1], 49];
```
Adds the iteration to the list of Itots:

```Mathematica
append[center_, 
  time_] := {If[upstream[center] == False, 
   Itots[[center]] = Append[Itots[[center]], Itot[center, time]], 
   Itots[[center]] = Append[Itots[[center]], 0]]}
```
We can now compute the total intercellular-volume using the following function:

```Mathematica
Itot[center_,time_]:=Min[waterdepth[[center]]*area,
	maxicvol[center]/weight[center,Mcell[center]],
	If[time==1,Infinity, minstoragevol[center]+Itots[[center]][[time]]]]
```

#### Depth Updating
Now, we can use our weights and total intercellular-volume to update the water depths of each cell. Each neighbor cell receives their respective weight times the total volume that leaves the center cell (Itot).

```Mathematica

Now, we can use our weights and total intercellular-volume to update the water depths of each cell. Each neighbor cell receives their respective weight times the total volume that leaves the center cell (Itot).

Icell[center_,i_,time_]:=weight[center,i]*Itot[center,time]

Icell[center_,time_]:= Itot[center,time]*weight[center]

Since water flows simultaneously, we must update all the cells at once. One iteration constitutes every cell in the grid being the center cell once. Those calculations are all based on the starting waterdepths, and the changes are stored in a temporary variable. 

We store the changes in a variable called changes.

changes=Table[0,49];

First, we define a function calculate that performs a calculation on all the cells in the grid.

calculate[center_,time_,changes_]:=If[
	upstream[center]==False,
	ReplacePart[changes,Join[{center->changes[[center]]- (Itot[center, time]/area)+(Icell[center,time]/area)},Table[
		x->changes[[x]]+(Icell[center, x, time]/area),
		{x, Select[neighbors[center], availstoragevol[center, #] > tolerance&]}
	]]],changes];

Then, we update all of the water depths at once. 

wmupdate[time_] := {
	Table[
		
		changes = calculate[x, time,changes];append[x,time];,{x, Length[elevationdata]}
	],
	
	waterdepth=waterdepth+changes;
	changes=Table[0,Length[elevationdata]];
}
```
#### Data Visualization

We will be using BarChart3D to visualize the model again. We will also use ArrayPlot to show how the water fluctuates as time passes.

```Mathematica
reset[dim_,wtrlvl_]:={Itots = Table[Table[0,1],dim^2];
changes=Table[0,dim^2];
waterdepth=Table[wtrlvl,dim^2];}
reset[7, 5];
```

##### Atlantic City

```Mathematica
ListAnimate[
 First /@ 
  Table[{Show[
     BarChart3D[Partition[elevationdata, 7], style, 
      ColorFunction -> "SiennaTones", 
      ChartElementFunction -> 
       Function[{xyz, z}, {Cuboid @@ Transpose@xyz}]], 
     BarChart3D[Partition[waterdepth + elevationdata, 7], style, 
      ColorFunction -> "DeepSeaColors", 
      ChartElementFunction -> 
       Function[{xyz, z}, {Opacity[.5], 
         Cuboid @@ Transpose@(0.0015223 + 0.999123 xyz)}]], 
     ImageSize -> Large], wmupdate[x]}, {x, 10}], 
 SaveDefinitions -> True]
```

<p align = 'center' >
<img width="428" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/7c66405b-9ffb-41c8-b289-bde825cc6cc3">

</p>

##### Princeton
We will apply this model on a portion of Princeton, New Jersey. To change dimensions, we re-define graph, area, and use the function reset.

```Mathematica
elevationdata=GeoElevationData[Entity["City",{"Princeton","NewJersey","UnitedStates"}],GeoRange->Quantity[500,"Meters"],GeoProjection->Automatic];
elevationdata=Flatten[QuantityMagnitude[Normal@elevationdata]];

elevationdata=elevationdata-Min[elevationdata];

graph=GridGraph[{36,36}];
area=500/Length[elevationdata];

```

Resets all the variables to initial values:

```Mathematica

reset[dim_,wtrlvl_]:={Itots = Table[Table[0,1],dim^2];
changes=Table[0,dim^2];
waterdepth=Table[wtrlvl,dim^2];}
reset[36,5];
```
Now, we visualize using ListAnimate
```Mathematica
ListAnimate[
 First /@ 
  Table[{ArrayPlot[Partition[waterdepth, 36], 
     ColorFunction -> 
      Function[{x}, ColorData["DeepSeaColors"][1 - x]]], 
    update[x, waterdepth]}, {x, 1, 10}]]
```

<p align = "center"> <img width="579" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/0acadc78-be7f-4f38-9fd7-ba6ecb854638"> </p>

Finally, we can type the reversed ArrayPlot of the GeoElevationData

```Mathematica
ArrayPlot[Partition[elevationdata, 36], 
 ColorFunction -> Function[{x}, ColorData["DeepSeaColors"][x]]]
```

<p align = "center"> 
<img width="360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/75b4a389-604c-4baf-97f9-2b3fe9f24084">
</p>

Looking at the ArrayPlot of the water depths and the reversed ArrayPlot elevation data, we can see they look pretty similar. This means that the lower the elevation, there is generally more water. This result is similar to the Bathtub model, except there are a few differences that distinguish the two. On larger datasets, this information can be helpful for disaster mitigation.



### HexagonalCellularAutomata Documentation

---

#### HexagonalGraphGen

```wolfram
HexagonalGraphGen[n_, m_]
```

**Description:**  
Generates a hexagonal graph with dimensions n x m.

**Parameters:**

*   `n` : The number of hexagonal cells in the horizontal direction.
*   `m` : The number of hexagonal cells in the vertical direction.

**Returns:**  
A `Graph` object representing the hexagonal graph.

---

#### InitializeCellularAutomata

```wolfram
InitializeCellularAutomata[geoPosition_, geoRange_, nodeDensity_, waterLevelFunction_]
```

**Description:**  
Initializes the cellular automata based on a given geographical position, range, node density, and water level function.

**Parameters:**

*   `geoPosition` : The geographical position (latitude, longitude) around which the hexagonal graph is centered.
*   `geoRange` : The geographical range (in km) that determines the extent of the hexagonal graph. This is the width of the square that the geographical data is taken from
*   `nodeDensity` : The desired density of the nodes in the hexagonal graph, measured in nodes per square km
*   `waterLevelFunction` : A function of position or number that defines the initial water level for each vertex. Water level is the thickness of water above the surface, not the total height of water above sea level.

**Returns:**  
A `Graph` object representing the initialized hexagonal graph with water and elevation data. (Although the funciton primarily updates internal datastructures)

---

#### InitVertexData

```wolfram
InitVertexData[graph_, groundHeightFunction_, waterLevelFunction_]
```

**Description:**  
Initializes the vertex data (ground height and water level) for a given hexagonal graph.

**Parameters:**

*   `graph` : The graph for which vertex data is to be initialized.
*   `groundHeightFunction` : A function to determine the ground height of each vertex.
*   `waterLevelFunction` : A function or number to determine the initial water level of each vertex. Water level is the thickness of water above the surface, not the total height of water above sea level.

**Returns:**  
No return value. This function updates interal data representations for the given graph.

---

#### VisualizeWaterData

```wolfram
VisualizeWaterData[graph_, vertexData_]
VisualizeWaterData[graph_, vertexData_, waterLevelSizeWeight_, groundLevelSizeWeight_]
```

**Description:**  
Provides a visualization of water data for a given hexagonal graph.

**Parameters:**

*   `graph` : The hexagonal graph.
*   `vertexData` : The data associated with each vertex (including ground height and water level).
*   `waterLevelScale` (optional): A scale factor to adjust the size visualization of the water level.
*   `groundHeightScale` (optional): A scale factor to adjust the size visualization of the ground height.

**Returns:**  
A visualization of the graph with vertices sized according to the water level and ground height.

---

#### VisualizeWaterData3D

```wolfram
VisualizeWaterData3D[graph_, vertexData_]
VisualizeWaterData3D[graph_, vertexData_, waterLevelScale_, groundHeightScale_]
```

**Description:**  
Provides a 3D visualization of water data for a given hexagonal graph.

**Parameters:**

*   `graph` : The hexagonal graph.
*   `vertexData` : The data associated with each vertex (including ground height and water level). This data should have been generated by the `GenerateWaterData` function.
*   `waterLevelScale` (optional): A scale factor to adjust the 3D visualization of the water level.
*   `groundHeightScale` (optional): A scale factor to adjust the 3D visualization of the ground height.

**Returns:**  
A 3D visualization of the graph showing ground heights and water levels.

---

#### GenerateWaterData

```wolfram
GenerateWaterData[graph_, iterations_, flowRate_]
```

**Description:**  
Simulates the cellular automata for a given number of iterations and returns the water data.

**Parameters:**

*   `graph` : The hexagonal graph.
*   `iterations` : The number of iterations to run the cellular automata.
*   `flowRate` : The rate at which water flows between adjacent vertices. Number from 0 to 1. Recommended value 0.9

**Returns:**  
A list of `vertexData` for each iteration. These can be used for analysis or visualization

---

#### Internal-Functions

1.  `NearestHexPoints`
    *   Finds the nearest hex points to a given point based on specified coordinates.
2.  `CalculateNeighborhoodNewWaterLevels`
    *   Calculates the new water levels for a vertex's neighborhood based on flow rate and current water levels.
3.  `CalculateGraphNewWaterLevels`
    *   Computes new water levels for all vertices in the graph.
4.  `UpdateGraphWaterLevels`
    *   Updates the water levels of all vertices in the graph based on computed drainage amounts.
5.  `FullUpdateGraph`
    *   Executes a full update on the graph, calculating new water levels and then updating them.

---


### Conclusion
With an increasing need for accurate models to mitigate impacts of flooding in urban areas and coastal regions, this project explores different approaches for water flow modeling: the bathtub inundation model and the cellular automata model. One challenges I encountered was considering the order of updating the cells and updating the grid simultaneously. Weighted cellular automata model provides a very gradient smooth distribution of water levels. Most of the water (~80%) is transferred within the first time step, and the other water fluctuates for the next few iterations. For smaller grids, the water is pretty constant by the 10th iteration. In this project, I learned about cellular automata and hopefully this model can be used in applications to predicting water spread and preventing large-scale floods.

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>
