using UnityEngine;
using UnityEngine.SceneManagement;
using Microsoft.MixedReality.Toolkit.UI;
using TMPro;

public class Manager : MonoBehaviour
{
    public GameObject SoftTarget, HardTarget, softSlider, hardSlider;
    public TMP_Text softVisibilityButtonText, hardVisibilityButtonText;
    public Material[] material; // Array of materials to switch between
    private new Renderer softRenderer, hardRenderer;
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
            softRenderer.enabled = true;
        }

        if (HardTarget != null)
        {
            hardRenderer = HardTarget.GetComponent<Renderer>();
            hardRenderer.enabled = true;
        }

        softSlider.SetActive(true);
        hardSlider.SetActive(true);
    }

    public void OnRestartTouch()
    {
        SceneManager.LoadScene("SampleScene"); // Load scene called "" from Start;
    }

    public void HideSoft(PinchSlider slider)
    {
        if (softDisabled)
        {
            ChangeAlpha(0, softRenderer);
            slider.SliderValue = 0;
            softVisibilityButtonText.text = "Show Soft Model";
            softDisabled = false;
        }
        else
        {
            ChangeAlpha(1, softRenderer);
            slider.SliderValue = 1;
            softVisibilityButtonText.text = "Hide Soft Model";
            softDisabled = true;
        }
    }

    public void HideHard(PinchSlider slider)
    {
        if (hardDisabled)
        {
            ChangeAlpha(0, hardRenderer);
            slider.SliderValue = 0;
            hardVisibilityButtonText.text = "Show Hard Model";
            hardDisabled = false;
        }
        else
        {
            ChangeAlpha(1, hardRenderer);
            slider.SliderValue = 1;
            hardVisibilityButtonText.text = "Hide Hard Model";
            hardDisabled = true;
        }
    }

    public void ChangeSoftOpacity(SliderEventData eventData)
    {
        ChangeAlpha(eventData.NewValue, softRenderer);
    }

    public void ChangeHardOpacity(SliderEventData eventData)
    {
        ChangeAlpha(eventData.NewValue, hardRenderer);
    }

    public void ChangeAlpha(float alphaVal, Renderer renderer)
    {
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
        if (softDist)
        {
            for (int i = 0; i < linerend.Length; i++)
            {
                linerend[i].gameObject.GetComponent<LineRenderer>().enabled = false;
                meshrend[i].gameObject.GetComponent<MeshRenderer>().enabled = false;
            }
            softDist = false;
        }
        else
        {
            for (int i = 0; i < linerend.Length; i++)
            {
                linerend[i].gameObject.GetComponent<LineRenderer>().enabled = true;
                meshrend[i].gameObject.GetComponent<MeshRenderer>().enabled = true;
            }
            softDist = true;
        }
    }

    public void HideHardDistance()
    {
        LineRenderer[] linerend = GameObject.FindObjectsOfType<LineRenderer>();
        TargetText[] meshrend = GameObject.FindObjectsOfType<TargetText>();
        if (hardDist)
        {
            for (int i = 0; i < linerend.Length; i++)
            {
                linerend[i].gameObject.GetComponent<LineRenderer>().enabled = false;
                meshrend[i].gameObject.GetComponent<MeshRenderer>().enabled = false;
            }
            hardDist = false;
        }
        else
        {
            for (int i = 0; i < linerend.Length; i++)
            {
                linerend[i].gameObject.GetComponent<LineRenderer>().enabled = true;
                meshrend[i].gameObject.GetComponent<MeshRenderer>().enabled = true;
            }
            hardDist = true;
        }
    }

    public void HideSoftLandmark()
    {
        TargetLandmarkSoft[] landTarget = GameObject.FindObjectsOfType<TargetLandmarkSoft>();
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
