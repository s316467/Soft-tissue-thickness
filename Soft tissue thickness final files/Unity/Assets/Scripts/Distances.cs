using System.Collections;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;

public class Distances : MonoBehaviour
{
    public GameObject ref1, ref2; // Two landmarks between which to calculate the distance
    public GameObject prefabText;
    public GameObject softParent, hardParent; // Parents for soft and hard tissues
    private float distance;
    private Dictionary<string, float> landmarkDistances;

    void Start()
    {
        // Load the landmark distances from the CSV file
        LoadLandmarkDistances("landmark_distances_mm_1.csv");

        // Print the landmark distances dictionary to the debug console
        PrintLandmarkDistances();

        // Fetch the distance using the standardized landmark names without the _soft or _hard suffix and right/left distinction
        string landmark1 = StandardizeLandmarkName(ref1.name);
        string landmark2 = StandardizeLandmarkName(ref2.name);

        if (landmarkDistances.TryGetValue(landmark1, out float distance1) && landmarkDistances.TryGetValue(landmark2, out float distance2))
        {
            distance = distance1; // Keep distance in mm

            // Debug log to check the distance fetched
            Debug.Log("Distance1: " + distance1 + " mm");
            Debug.Log("Distance2: " + distance2 + " mm");

            // Graphical indication of the Euclidean distance via Line Renderer
            DrawLine(ref1.transform.position, ref2.transform.position);

            // Textual indication of the Euclidean distance value in millimeters
            Distancetext(ref1.transform.position, ref2.transform.position, distance);
        }
        else
        {
            Debug.LogError("Landmark names not found in the CSV file");
        }
    }

    private void LoadLandmarkDistances(string filePath)
    {
        // Read the CSV file and store the distances in a dictionary
        landmarkDistances = new Dictionary<string, float>();
        string[] lines = System.IO.File.ReadAllLines(filePath);

        foreach (string line in lines.Skip(1)) // Skip the header line
        {
            string[] parts = line.Split(',');
            if (parts.Length >= 2)
            {
                string landmark = parts[0].Trim();
                if (float.TryParse(parts[1].Trim(), System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out float distance))
                {
                    // Round the distance to two decimal places
                    distance = Mathf.Round(distance * 100f) / 100f;
                    landmarkDistances[landmark] = distance;
                }
            }
        }
    }

    private string StandardizeLandmarkName(string objectName)
    {
        Debug.Log("Original object name: " + objectName);

        // Remove the _soft or _hard suffix
        if (objectName.EndsWith("_soft"))
        {
            objectName = objectName.Replace("_soft", "");
        }
        else if (objectName.EndsWith("_hard"))
        {
            objectName = objectName.Replace("_hard", "");
        }

        // Replace _dx with Right and _sx with Left
        objectName = objectName.Replace("_dx", " Right").Replace("_sx", " Left");

        Debug.Log("After replacing dx/sx and removing suffix: " + objectName);

        // Split the name into words based on underscores and spaces
        string[] words = objectName.Split(new char[] { '_', ' ' }, System.StringSplitOptions.RemoveEmptyEntries);
        for (int i = 0; i < words.Length; i++)
        {
            // Convert the first letter of each word to uppercase and the rest to lowercase
            if (words[i].Length > 0)
            {
                words[i] = char.ToUpper(words[i][0]) + words[i].Substring(1).ToLower();
            }
        }

        // Join the words back together with spaces
        objectName = string.Join(" ", words);

        Debug.Log("Final standardized name: " + objectName);
        return objectName;
    }


    private void PrintLandmarkDistances()
    {
        Debug.Log("Printing Landmark Distances:");
        foreach (KeyValuePair<string, float> entry in landmarkDistances)
        {
            Debug.Log($"Landmark: {entry.Key}, Distance: {entry.Value} mm");
        }
    }

    public void DrawLine(Vector3 firstLand, Vector3 secondLand)
    {
        // Instantiate a new GameObject for drawing the line
        GameObject drawline = new GameObject("DistanceLine");

        // Determine parent based on the landmarks
        drawline.transform.SetParent(DetermineParent(ref1, ref2).transform, false);

        // Add the Line Renderer component and modify its properties
        LineRenderer line = drawline.AddComponent<LineRenderer>();
        line.useWorldSpace = true;
        Shader shader = Shader.Find("Sprites/Default"); // Using a default shader to ensure visibility
        Material mat = new Material(shader) { color = Color.black };
        line.material = mat;
        line.startWidth = 0.001f; // Line width at the start
        line.endWidth = 0.0001f; // Line width at the end
        line.positionCount = 2;
        line.SetPosition(0, firstLand); // Start position
        line.SetPosition(1, secondLand); // End position
    }

    public void Distancetext(Vector3 firstLand, Vector3 secondLand, float distance)
    {
        Debug.Log("Distancetext method called");

        // Calculate the position for the text, slightly offset from the midpoint
        Vector3 textPosition = Vector3.Lerp(firstLand, secondLand, 0.5f) + new Vector3(0.008f, 0, 0);

        // Instantiate the text prefab at the calculated position
        GameObject txt = Instantiate(prefabText, textPosition, Quaternion.identity);

        if (txt == null)
        {
            Debug.LogError("Failed to instantiate prefabText. Please ensure it is assigned in the inspector.");
            return;
        }

        // Determine the appropriate parent object (soft or hard)
        txt.transform.SetParent(DetermineParent(ref1, ref2).transform, true); // Use worldPositionStays = true to maintain the world position

        // Ensure the TextMeshPro component exists
        TextMeshPro textComponent = txt.GetComponent<TextMeshPro>();
        if (textComponent == null)
        {
            Debug.LogError("TextMeshPro component is missing on the prefabText. Please add it.");
            return;
        }

        // Set the distance text in millimeters, formatted to two decimal places
        textComponent.text = $"{distance.ToString("F2", System.Globalization.CultureInfo.InvariantCulture)} <size=75%>mm</size>";

        // Set the text alignment to middle center to ensure it stays on the same line
        textComponent.alignment = TextAlignmentOptions.Center;

        // Set the text color to blue
        textComponent.color = Color.blue;
    }


    private GameObject DetermineParent(GameObject ref1, GameObject ref2)
    {
        // Check and log the soft/hard status of ref1 and ref2
        bool isRef1Soft = IsSoft(ref1);
        bool isRef2Soft = IsSoft(ref2);
        bool isRef1Hard = IsHard(ref1);
        bool isRef2Hard = IsHard(ref2);

        Debug.Log($"ref1 is soft: {isRef1Soft}, ref2 is soft: {isRef2Soft}");
        Debug.Log($"ref1 is hard: {isRef1Hard}, ref2 is hard: {isRef2Hard}");

        // Determine parent based on the landmarks
        if (isRef1Soft && isRef2Soft)
        {
            Debug.Log("Assigning to soft parent");
            return softParent;
        }
        else if (isRef1Hard && isRef2Hard)
        {
            Debug.Log("Assigning to hard parent");
            return hardParent;
        }
        else
        {
            // If one is soft and one is hard, decide how to handle it.
            // For this example, we'll use the soft parent.
            Debug.Log("Assigning to soft parent (mixed soft/hard)");
            return softParent;
        }
    }

    private bool IsSoft(GameObject obj)
    {
        // Determine if the GameObject is soft by checking its name
        bool result = obj.name.Contains("_soft");
        Debug.Log($"IsSoft check for {obj.name}: {result}");
        return result;
    }

    private bool IsHard(GameObject obj)
    {
        // Determine if the GameObject is hard by checking its name
        bool result = obj.name.Contains("_hard");
        Debug.Log($"IsHard check for {obj.name}: {result}");
        return result;
    }
}
