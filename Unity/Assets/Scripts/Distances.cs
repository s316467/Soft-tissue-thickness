using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class Distances : MonoBehaviour
{
    public GameObject ref1, ref2; // Two landmarks between which to calculate the distance
    public GameObject prefabText;
    public GameObject softParent, hardParent; // Parents for soft and hard tissues
    private float distance;

    void Start()
    {
        // Calculate the Euclidean distance in meters using world positions
        distance = Vector3.Distance(ref1.transform.position, ref2.transform.position);

        // Debug log to check the distance calculated
        Debug.Log("Distance: " + distance + " meters");

        // Graphical indication of the Euclidean distance via Line Renderer
        DrawLine(ref1.transform.position, ref2.transform.position);

        // Textual indication of the Euclidean distance value in centimeters
        Distancetext(ref1.transform.position, ref2.transform.position, distance);
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
        // Convert distance from meters to centimeters
        float distanceInCm = distance * 100;

        // Instantiate the prefab at the midpoint between the two landmarks
        GameObject txt = Instantiate(prefabText, Vector3.Lerp(firstLand, secondLand, 0.5f) + new Vector3(0.008f, 0, 0), Quaternion.identity);

        // Determine parent based on the landmarks
        txt.transform.SetParent(DetermineParent(ref1, ref2).transform, false);

        TextMeshPro tmp = txt.GetComponent<TextMeshPro>();
        if (tmp != null)
        {
            tmp.text = distanceInCm.ToString("F2") + " cm"; // Assign a value to the text
            tmp.color = Color.blue; // Assign a color to the text
        }
        else
        {
            Debug.LogError("TextMeshPro component is missing on the prefabText.");
        }
    }

    private GameObject DetermineParent(GameObject ref1, GameObject ref2)
    {
        // Logic to determine the appropriate parent (soft or hard) based on your criteria
        // For this example, we assume ref1 belongs to soft and ref2 belongs to hard

        if (IsSoft(ref1) && IsSoft(ref2))
        {
            return softParent;
        }
        else if (IsHard(ref1) && IsHard(ref2))
        {
            return hardParent;
        }
        else
        {
            // If one is soft and one is hard, you can choose how to handle it.
            // For example, use the soft parent:
            return softParent;
        }
    }

    private bool IsSoft(GameObject obj)
    {
        // Your logic to determine if the GameObject is soft
        // Placeholder example:
        return obj.name.Contains("soft");
    }

    private bool IsHard(GameObject obj)
    {
        // Your logic to determine if the GameObject is hard
        // Placeholder example:
        return obj.name.Contains("hard");
    }
}
