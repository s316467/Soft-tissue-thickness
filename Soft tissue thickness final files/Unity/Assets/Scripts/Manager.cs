using UnityEngine;
using UnityEngine.SceneManagement;
using Microsoft.MixedReality.Toolkit.UI;
using TMPro;

public class Manager : MonoBehaviour
{
    public GameObject SoftTarget, HardTarget, softSlider, hardSlider;
    public TMP_Text softVisibilityButtonText, hardVisibilityButtonText;
    public Material[] material; // Array of materials to switch between
    private Renderer softRenderer, hardRenderer;
    private bool softDisabled = true;
    private bool hardDisabled = true;
    private bool softDist = true;
    private bool hardDist = true;
    private bool softLand = true;
    private bool hardLand = true;

    // Start is called before the first frame update
    void Start()
    {
        if (SoftTarget == null) // SoftTarget not assigned through the inspector
        {
            SimpleTargetSoft softSimpleTarget = GameObject.FindObjectOfType<SimpleTargetSoft>();
            if (softSimpleTarget != null)
            {
                SoftTarget = softSimpleTarget.gameObject;
            }
        }
        if (HardTarget == null) // HardTarget not assigned through the inspector
        {
            SimpleTargetHard hardSimpleTarget = GameObject.FindObjectOfType<SimpleTargetHard>();
            if (hardSimpleTarget != null)
            {
                HardTarget = hardSimpleTarget.gameObject;
            }
        }

        if (SoftTarget != null)
        {
            softRenderer = SoftTarget.GetComponent<Renderer>();
            if (softRenderer != null)
            {
                softRenderer.enabled = true;
            }
            else
            {
                Debug.LogError("SoftTarget does not have a Renderer component.");
            }
        }

        if (HardTarget != null)
        {
            hardRenderer = HardTarget.GetComponent<Renderer>();
            if (hardRenderer != null)
            {
                hardRenderer.enabled = true;
            }
            else
            {
                Debug.LogError("HardTarget does not have a Renderer component.");
            }
        }

        if (softSlider != null)
        {
            softSlider.SetActive(true);
        }
        else
        {
            Debug.LogError("softSlider is not assigned.");
        }

        if (hardSlider != null)
        {
            hardSlider.SetActive(true);
        }
        else
        {
            Debug.LogError("hardSlider is not assigned.");
        }
    }

    public void OnRestartTouch()
    {
        SceneManager.LoadScene("SampleScene"); // Load scene called "" from Start;
    }

    public void HideSoft(PinchSlider slider)
    {
        if (softRenderer == null)
        {
            Debug.LogError("SoftRenderer is not assigned.");
            return;
        }

        if (softDisabled)
        {
            ChangeAlpha(0, softRenderer);
            if (slider != null)
            {
                slider.SliderValue = 0;
            }
            if (softVisibilityButtonText != null)
            {
                softVisibilityButtonText.text = "Show Soft Model";
            }
            softDisabled = false;
        }
        else
        {
            ChangeAlpha(1, softRenderer);
            if (slider != null)
            {
                slider.SliderValue = 1;
            }
            if (softVisibilityButtonText != null)
            {
                softVisibilityButtonText.text = "Hide Soft Model";
            }
            softDisabled = true;
        }
    }

    public void HideHard(PinchSlider slider)
    {
        if (hardRenderer == null)
        {
            Debug.LogError("HardRenderer is not assigned.");
            return;
        }

        if (hardDisabled)
        {
            ChangeAlpha(0, hardRenderer);
            if (slider != null)
            {
                slider.SliderValue = 0;
            }
            if (hardVisibilityButtonText != null)
            {
                hardVisibilityButtonText.text = "Show Hard Model";
            }
            hardDisabled = false;
        }
        else
        {
            ChangeAlpha(1, hardRenderer);
            if (slider != null)
            {
                slider.SliderValue = 1;
            }
            if (hardVisibilityButtonText != null)
            {
                hardVisibilityButtonText.text = "Hide Hard Model";
            }
            hardDisabled = true;
        }
    }

    public void ChangeSoftOpacity(SliderEventData eventData)
    {
        if (softRenderer != null)
        {
            ChangeAlpha(eventData.NewValue, softRenderer);
        }
        else
        {
            Debug.LogError("SoftRenderer is not assigned.");
        }
    }

    public void ChangeHardOpacity(SliderEventData eventData)
    {
        if (hardRenderer != null)
        {
            ChangeAlpha(eventData.NewValue, hardRenderer);
        }
        else
        {
            Debug.LogError("HardRenderer is not assigned.");
        }
    }

    public void ChangeAlpha(float alphaVal, Renderer renderer)
    {
        if (renderer == null)
        {
            Debug.LogError("Renderer is null.");
            return;
        }

        if (material == null || material.Length < 2)
        {
            Debug.LogError("Material array is not properly assigned.");
            return;
        }

        if (alphaVal == 1)
        {
            renderer.sharedMaterial = material[1]; // Opaque material
        }
        else
        {
            renderer.sharedMaterial = material[0]; // Fade material
            Color fadeColor = material[0].color;
            fadeColor.a = alphaVal;
            material[0].SetColor("_Color", fadeColor);
        }
    }

    public void HideSoftDistance()
    {
        LineRenderer[] linerend = GameObject.FindObjectsOfType<LineRenderer>();
        TargetText[] meshrend = GameObject.FindObjectsOfType<TargetText>();

        // Debug.Log("Number of LineRenderers: " + linerend.Length);
        // Debug.Log("Number of TargetTexts: " + meshrend.Length);

        if (linerend.Length != meshrend.Length)
        {
            Debug.LogError("The number of LineRenderers and TargetTexts do not match.");
            return;
        }

        if (softDist)
        {
            for (int i = 0; i < linerend.Length; i++)
            {
                linerend[i].enabled = false;
                if (i < meshrend.Length)
                {
                    meshrend[i].gameObject.GetComponent<MeshRenderer>().enabled = false;
                }
            }
            softDist = false;
        }
        else
        {
            for (int i = 0; i < linerend.Length; i++)
            {
                linerend[i].enabled = true;
                if (i < meshrend.Length)
                {
                    meshrend[i].gameObject.GetComponent<MeshRenderer>().enabled = true;
                }
            }
            softDist = true;
        }
    }

    public void HideHardDistance()
    {
        LineRenderer[] linerend = GameObject.FindObjectsOfType<LineRenderer>();
        TargetText[] meshrend = GameObject.FindObjectsOfType<TargetText>();

        if (linerend.Length != meshrend.Length)
        {
            Debug.LogError("The number of LineRenderers and TargetTexts do not match.");
            return;
        }

        if (hardDist)
        {
            for (int i = 0; i < linerend.Length; i++)
            {
                linerend[i].enabled = false;
                if (i < meshrend.Length)
                {
                    meshrend[i].gameObject.GetComponent<MeshRenderer>().enabled = false;
                }
            }
            hardDist = false;
        }
        else
        {
            for (int i = 0; i < linerend.Length; i++)
            {
                linerend[i].enabled = true;
                if (i < meshrend.Length)
                {
                    meshrend[i].gameObject.GetComponent<MeshRenderer>().enabled = true;
                }
            }
            hardDist = true;
        }
    }

    public void HideSoftLandmark()
    {
        TargetLandmarkSoft[] landTarget = GameObject.FindObjectsOfType<TargetLandmarkSoft>();

        if (landTarget == null)
        {
            Debug.LogError("No TargetLandmarkSoft objects found.");
            return;
        }

        if (softLand)
        {
            for (int i = 0; i < landTarget.Length; i++)
            {
                landTarget[i].gameObject.GetComponent<MeshRenderer>().enabled = false;
            }
            softLand = false;
        }
        else
        {
            for (int i = 0; i < landTarget.Length; i++)
            {
                landTarget[i].gameObject.GetComponent<MeshRenderer>().enabled = true;
            }
            softLand = true;
        }
    }

    public void HideHardLandmark()
    {
        TargetLandmarkHard[] landTarget = GameObject.FindObjectsOfType<TargetLandmarkHard>();

        if (landTarget == null)
        {
            Debug.LogError("No TargetLandmarkHard objects found.");
            return;
        }

        if (hardLand)
        {
            for (int i = 0; i < landTarget.Length; i++)
            {
                landTarget[i].gameObject.GetComponent<MeshRenderer>().enabled = false;
            }
            hardLand = false;
        }
        else
        {
            for (int i = 0; i < landTarget.Length; i++)
            {
                landTarget[i].gameObject.GetComponent<MeshRenderer>().enabled = true;
            }
            hardLand = true;
        }
    }
}
