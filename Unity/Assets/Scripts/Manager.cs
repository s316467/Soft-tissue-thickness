using UnityEngine;
using UnityEngine.SceneManagement;
using Microsoft.MixedReality.Toolkit.UI;
using TMPro;
public class Manager : MonoBehaviour
{
    public GameObject Target, slider;
    public TMP_Text visibilityButtonText;
    public Material[] material; // vettore di materiali fra cui switchare
    private new Renderer renderer;
    private bool disabled = true;
    private bool dist = true;
    private bool land = true;
    // Start is called before the first frame update
    void Start()
    {
        if (Target == null) //Target not assigned through the inspector
        {
            //Search Target GameObject with associated class
            //Finding GameObject with associated scripts is the most robust and secure way
            SimpleTarget simpleTarget = GameObject.FindObjectOfType<SimpleTarget>();
            if (simpleTarget != null)
            {
                Target = simpleTarget.gameObject;
            }
        }
        renderer = Target.GetComponent<Renderer>();
        renderer.enabled = true;
        slider.SetActive(true);
    }
    public void OnRestartTouch()
    {
        SceneManager.LoadScene("02_Landmark"); //Load scene called "" from Start;
    }
    public void Hide(PinchSlider slider)
    {
        if (disabled)
        {
            //Call della funzione ChangeAlpha con input il valore di alpha=0 --> trasparenza totale
            ChangeAlpha(0);
            //aggiorno il valore dello slider
            slider.SliderValue = 0;
            //aggiorno il testo del button
            visibilityButtonText.text = "Show Model";
            disabled = false;
        }
        else
        {
            //Call della funzione ChangeAlpha con input il valore di alpha=1 --> opacità totale
            ChangeAlpha(1);
            //aggiorno il valore dello slider
            slider.SliderValue = 1;
            //aggiorno il testo del button
            visibilityButtonText.text = "Hide Model";
            disabled = true;
        }
    }
    public void ChangeOpacity(SliderEventData eventData)
    {
        // Call della funzione ChangeAlpha con input il valore di alpha indicato sullo slider
        ChangeAlpha(eventData.NewValue);
    }
    public void ChangeAlpha(float alphaVal)
    {
        if (alphaVal == 1)
        {
            // render del materiale opaco
            renderer.sharedMaterial = material[1];
        }
        else
        {
            // render del materiale fade
            renderer.sharedMaterial = material[0];
            // assegno alla variabile fadeColor di tipo Color il colore corrente del materiale fade
            Color fadeColor = material[0].color;
            // modifico il valore del canale alpha assegnando il valore di alpha in input
            fadeColor.a = alphaVal;
            //setto il nuovo colore per il materiale fade
            material[0].SetColor("_Color", fadeColor);
        }
    }
    public void Hidedistance()
    {
        LineRenderer[] linerend = GameObject.FindObjectsOfType<LineRenderer>();
        TargetText[] meshrend = GameObject.FindObjectsOfType<TargetText>();
        if (dist)
        {
            for (int i = 0; i < linerend.Length; i++)
            {
                linerend[i].gameObject.GetComponent<LineRenderer>().enabled = false;
                meshrend[i].gameObject.GetComponent<MeshRenderer>().enabled = false;
            }
            dist = false;
        }
        else
        {
            for (int i = 0; i < linerend.Length; i++)
            {
                linerend[i].gameObject.GetComponent<LineRenderer>().enabled = true;
                meshrend[i].gameObject.GetComponent<MeshRenderer>().enabled = true;
            }
            dist = true;
        }
    }
    public void Hidelandmark()
    {
        TargetLandmark[] landTarget = GameObject.FindObjectsOfType<TargetLandmark>();
        if (land)
        {
            for (int i = 0; i < landTarget.Length; i++)
            {
                landTarget[i].gameObject.GetComponent<MeshRenderer>().enabled = false;
            }
            land = false;
        }
        else
        {
            for (int i = 0; i < landTarget.Length; i++)
            {
                landTarget[i].gameObject.GetComponent<MeshRenderer>().enabled = true;
            }
            land = true;
        }
    }
}