{-# LANGUAGE OverloadedStrings #-}

module Tests.MetricTests(allMetricTests,allMetricProperties) where 

import Tests.TestSuite
import Test.HUnit hiding (Node,Path)

import Test.Framework.Providers.QuickCheck2
import Test.QuickCheck(forAll, listOf, listOf1,Property)

import Data.Text(Text(..))

allMetricTests = TestList [
    TestLabel "magnitudes_singleSentenceGraph_shouldBeSentenceLength" magnitudes_singleSentenceGraph_shouldBeSentenceLength
    ,TestLabel "averagedMagnitudes_singleSentenceGraph_shouldBeOne" averagedMagnitudes_singleSentenceGraph_shouldBeOne
    ,TestLabel "edgeStrength_singleSentenceGraph_shouldBeSentenceLengthMinusOne" edgeStrength_singleSentenceGraph_shouldBeSentenceLengthMinusOne
    ,TestLabel "averagedEdgeStrength_singleSentenceGraph_shouldBeSmallerOne" averagedEdgeStrength_singleSentenceGraph_shouldBeSmallerOne

    ,TestLabel "magnitudes_DoubleSentenceGraph_shouldBeTwiceSentenceLength" magnitudes_DoubleSentenceGraph_shouldBeTwiceSentenceLength
    ,TestLabel "averagedMagnitudes_DoubleSentenceGraph_shouldBeTwo" averagedMagnitudes_DoubleSentenceGraph_shouldBeTwo
    ,TestLabel "edgeStrength_DoubleSentenceGraph_shouldBeTwoTimesSentenceLengthMinusTwo" edgeStrength_DoubleSentenceGraph_shouldBeTwoTimesSentenceLengthMinusTwo
    ,TestLabel "averagedEdgeStrength_DoubleSentenceGraph_shouldBeBiggerThanOneAndSmallerThanTwo" averagedEdgeStrength_DoubleSentenceGraph_shouldBeBiggerThanOneAndSmallerThanTwo
    ]

allMetricProperties = [
    testProperty "cosineSim of same element is 1" prop_cosineSimReflexivity,
    testProperty "cosineSim of empty list is 0" prop_cosineSimEmptyElem,
    testProperty "cosineSim is symmetric" prop_cosineSimSymmetry,
    testProperty "cosineSim is always between 0 and 1" prop_cosineSimValueRange,
    testProperty "jaccardSim to itself is 1" prop_jaccardSimReflexivity,
    testProperty "jaccardSim of empty list is 0" prop_jaccardSimEmptyElem,
    testProperty "jaccardSim is symmetric" prop_jaccardSimSymmetry,
    testProperty "jaccardSim is always between 0 and 1" prop_jaccardSimValueRange
    ]

magnitudes_singleSentenceGraph_shouldBeSentenceLength = 
    4 ~=? magnitudes testPath 
        where 
            testGraph = toGraphOne "Hello I am Test"
            testPaths = allPaths testGraph 
            testPath = head testPaths

averagedMagnitudes_singleSentenceGraph_shouldBeOne =
    1 ~=? averagedMagnitudes testPath 
        where 
            testGraph = toGraphOne "Hello I am Test"
            testPaths = allPaths testGraph 
            testPath = head testPaths


edgeStrength_singleSentenceGraph_shouldBeSentenceLengthMinusOne = 
    3 ~=? edgeStrengths testPath 
        where 
            testGraph = toGraphOne "Hello I am Test"
            testPaths = allPaths testGraph 
            testPath = head testPaths

averagedEdgeStrength_singleSentenceGraph_shouldBeSmallerOne =
    True ~=? 1> averagedEdgeStrengths testPath && 0 <  averagedEdgeStrengths testPath
        where 
            testGraph = toGraphOne "Hello I am Test"
            testPaths = allPaths testGraph 
            testPath = head testPaths

magnitudes_DoubleSentenceGraph_shouldBeTwiceSentenceLength = 
    8 ~=? magnitudes testPath 
        where 
            testGraph = toGraphMany ["Hello I am Test","Hello I am Test"]
            testPaths = allPaths testGraph 
            testPath = head testPaths

averagedMagnitudes_DoubleSentenceGraph_shouldBeTwo = 
    2 ~=? averagedMagnitudes testPath 
        where 
            testGraph = toGraphMany ["Hello I am Test","Hello I am Test"]
            testPaths = allPaths testGraph 
            testPath = head testPaths

edgeStrength_DoubleSentenceGraph_shouldBeTwoTimesSentenceLengthMinusTwo = 
    6 ~=? edgeStrengths testPath 
        where 
            testGraph = toGraphMany ["Hello I am Test","Hello I am Test"]
            testPaths = allPaths testGraph 
            testPath = head testPaths

averagedEdgeStrength_DoubleSentenceGraph_shouldBeBiggerThanOneAndSmallerThanTwo = 
    True ~=? 2> averagedEdgeStrengths testPath && 1 <  averagedEdgeStrengths testPath 
        where 
            testGraph = toGraphMany ["Hello I am Test","Hello I am Test"]
            testPaths = allPaths testGraph 
            testPath = head testPaths


prop_cosineSimReflexivity :: Property
prop_cosineSimReflexivity = 
    forAll (listOf1 arbitrary) cosineSimReflexivity
    where 
        cosineSimReflexivity :: Path -> Bool
        cosineSimReflexivity p = 
            cosineSim p p == 1.0 

prop_cosineSimEmptyElem p = 
    cosineSim p [] == 0 && cosineSim [] p == 0

prop_cosineSimSymmetry p1 p2 = 
    cosineSim p1 p2 == cosineSim p2 p1

prop_cosineSimValueRange p1 p2 =
    dist >= 0.0 && dist <= 1.0
    where dist = cosineSim p1 p2 

prop_jaccardSimReflexivity :: Property
prop_jaccardSimReflexivity = 
    forAll (listOf1 arbitrary) jaccardSimReflexivity
    where 
        jaccardSimReflexivity :: Path -> Bool
        jaccardSimReflexivity p = 
            jaccardSim p p == 1.0 

prop_jaccardSimEmptyElem p = 
    jaccardSim p [] == 0 && jaccardSim [] p == 0

prop_jaccardSimSymmetry p1 p2 = 
    jaccardSim p1 p2 == jaccardSim p2 p1

prop_jaccardSimValueRange p1 p2 =
    dist >= 0.0 && dist <= 1.0 
    where dist = jaccardSim p1 p2  
