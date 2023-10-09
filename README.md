# WaterGate
Welcome to the WaterGate documentation! WaterGate is an accessible computational analysis of flooding patterns written in the Wolfram Language. 

## Abstract
240 million people are affected by floods each year, reflecting the urgent need for accessible flood prediction and detection. WaterGate is a computational model that uses geographic elevation data and the rational method to predict flooding patterns , generating an interactive 3D model for user accessibility. Computational hydrology applies numerical methods, machine learning algorithms, and computational simulations to understand, predict, and manage water resources - including floods. Our project employs computational hydrology by analyzing the structure of river tributaries in 2D through polygon clustering, satellite imaging, and various cleaning protocols. We developed respective tributary tree graphs, morphological graphs, and nodes to create a comprehensive tree and 3D model. Afterward, we examine the morphology of flood plains in 3D space, implementing the rational method (Q = C iA) framework with curated relief plots to predict, model, and visualize flooding elevation. Then, we constructed our stream order analysis, waterline delineation, and statistical analysis to validate our data. Lastly, we modeled different river systems and developed further extensions to increase the applicability of WaterGate to communities around the world.

## Documentation 
This will not be a traditional documentation - rather, it will focus on the code that we've written and how you can implement it if you code in the Wolfram Language

### Isolating Rivers from Maps 
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

### Creating Morphological Graphs and Tree Graphs

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

### Finding Stream Splits on Morphological Graphs

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

### Mapping River Branches on Maps

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

#### Application to Simple River Systems

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
<img width="299" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/7b2ba3d8-2713-4618-b4fc-e1bee0dd1b30"> <img width="287" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/a3f0f230-9714-41c6-9850-1f43cadebbfb"> <img width="287" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/6e5021d4-db75-4f9a-823b-a76fdfcd00e0">
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


#### Application to Complex River Systems

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
 <img width="260" height = "360" alt="image" src="https://github.com/navvye/WaterGate/assets/25653940/a3657913-9d16-4c6c-9c9c-992bbe89396b">
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


### 2-D Satellite Mapping onto 3-D Model 

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

### Relief Plot for Flood Plain

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


### Rational Method (Q = CiA) Introduction and Usage

The rational method  is used for determining peak discharges; this method is traditionally used to size storm sewers, channels, and other stormwater structures.

The rational method formula is expressed as Q = CiA where: Q = Peak rate of runoff in cubic feet per second; C = Runoff coefficient, an empirical coefficient representing a relationship between rainfall and runoff; i = Average intensity of rainfall in inches per hour for the time of concentration for a selected frequency of occurrence or return period; A = The watershed area in acre. In this section, we will be calculating each of these variables and parameterizing them for any geographic location. 
#### C Calculation
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

#### I Calculation

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

#### A Calculation

A is the area of the flood plain in acres; current data was in miles. To convert miles to acres, we have to square the region boundaries (the return result will be in square miles), then multiply by 640.
```Mathematica
juneauAcres = 20^2*640
```
Which gives us A = 256000

#### CiA (Q Calculation) & River Runoff Calculation

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

### Relief Calculation Integration and Flood Analysis 

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

#### Application to Simple River Systems
