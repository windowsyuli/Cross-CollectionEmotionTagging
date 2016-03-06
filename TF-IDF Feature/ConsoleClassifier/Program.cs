using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using SharpICTCLAS;

namespace ConsoleClassifier
{
    class Program
    {
        static List<string> StopWords = new List<string>();
        static List<string> EmotionTerm = new List<string>();

        static List<string> EmotionTermA = new List<string>();
        static List<string> EmotionTermB = new List<string>();

        static List<string> AandB = new List<string>();
        static List<string> AorB = new List<string>();

        static List<int> EmotionTermADoc = new List<int>();
        static List<int> EmotionTermBDoc = new List<int>();

        static List<int> AAandBDoc = new List<int>();
        static List<int> AAorBDoc = new List<int>();
        static List<int> BAandBDoc = new List<int>();
        static List<int> BAorBDoc = new List<int>();

        static List<string[]> EmotionStringA = new List<string[]>();
        static List<string[]> EmotionStringB = new List<string[]>();

        static List<string[]> StringA = new List<string[]>();
        static List<string[]> StringB = new List<string[]>();

        static List<double[]> EmotionProA = new List<double[]>();
        static List<double[]> EmotionProB = new List<double[]>();

        static List<double[]> EmotionFeatureA = new List<double[]>();
        static List<double[]> FeatureAinAandB = new List<double[]>();
        static List<double[]> FeatureAinAorB = new List<double[]>();

        static List<double[]> EmotionFeatureB = new List<double[]>();
        static List<double[]> FeatureBinAandB = new List<double[]>();
        static List<double[]> FeatureBinAorB = new List<double[]>();

        static StreamWriter Log = new StreamWriter("Log.txt");
        static string stopwordspath = "stopwordsbutnot.txt";
        static string emotiontermpath = "emotiontermdicSegment.txt";
        static string emotionA = "SinaEnt";
        static string emotionB = "QQEnt";
        static int Thre = 20;
        static int NumA = 8;
        static int NumB = 8;
        static int[] VotesA = new int[NumA];
        static int[] VotesB = new int[NumB];
        static char[] Punctions = { '~', '，', '、', '|', '。', '。', '。', '；', '.', ';', '?', '？', '！', '!', '\n', '\r', ' ', '\t', '“', '皊', '”', '寶', '癡' };
        static WordSegment ws = new WordSegment();
        static string[] AAA = new string[] { "A", "B", "C", "D", "E", "F", "G", "H" };
        static void Main(string[] args)
        {
            ReadWords(stopwordspath, StopWords);
            ReadWords(emotiontermpath, EmotionTerm);
            ws.InitWordSegment(".\\Dic\\");
            ReadNews(emotionA, EmotionStringA, StringA, EmotionProA, Thre, NumA, VotesA);
            ReadNews(emotionB, EmotionStringB, StringB, EmotionProB, Thre, NumB, VotesB);
            Digestion();
            Console.WriteLine("1");
            WriterInt(EmotionFeatureA, "EmotionFeatureA");
            WriterArff(EmotionFeatureA, EmotionTermA, "EmotionFeatureA", EmotionProA);
            Console.WriteLine("2");
            WriterInt(FeatureAinAandB, "FeatureAinAandB");
            WriterArff(FeatureAinAandB, AandB, "FeatureAinAandB", EmotionProA);
            Console.WriteLine("3");
            WriterInt(FeatureAinAorB, "FeatureAinAorB");
            WriterArff(FeatureAinAorB, AorB, "FeatureAinAorB", EmotionProA);
            Console.WriteLine("4");
            WriterInt(EmotionFeatureB, "EmotionFeatureB");
            WriterArff(EmotionFeatureB, EmotionTermB, "EmotionFeatureB", EmotionProB);
            Console.WriteLine("5");
            WriterInt(FeatureBinAandB, "FeatureBinAandB");
            WriterArff(FeatureBinAandB, AandB, "FeatureBinAandB", EmotionProB);
            Console.WriteLine("6");
            WriterInt(FeatureBinAorB, "FeatureBinAorB");
            WriterArff(FeatureBinAorB, AorB, "FeatureBinAorB", EmotionProB);
            Console.WriteLine("7");
            WriterDouble(EmotionProA, "EmotionProA");
            Console.WriteLine("8");
            WriterDouble(EmotionProB, "EmotionProB");
            Log.Close();
        }
        static void WriterArff(List<double[]> Emotion, List<string> words, string name, List<double[]> pro)
        {
            using (StreamWriter sw = new StreamWriter(".\\Result\\" + name + ".arff"))
            {
                sw.WriteLine("@relation result");
                for (int i = 0; i < words.Count; ++i)
                    sw.WriteLine("@ATTRIBUTE " + i.ToString() + " REAL");
                if (pro[0].Length == 6)
                    sw.WriteLine("@ATTRIBUTE CLASS { A,B,C,D,E,F}");
                else
                    sw.WriteLine("@ATTRIBUTE CLASS { A,B,C,D,E,F,G,H}");
                sw.WriteLine("@data");
                for (int i = 0; i < Emotion.Count; ++i)
                {
                    string str = "{";
                    for (int j = 0; j < Emotion[i].Length; j += 2)
                        str += ((int)Emotion[i][j]).ToString() + " " + Emotion[i][j + 1].ToString() + ",";
                    int index = -1;
                    double max = 0;
                    for (int j = 0; j < pro[i].Length; j++)
                        if (pro[i][j] > max)
                        {
                            index = j;
                            max = pro[i][j];
                        }
                    if (index >= 0)
                    {
                        str += words.Count + " " + AAA[index] + "}";
                        sw.WriteLine(str);
                    }
                }
            }
        }
        static void WriterInt(List<double[]> Emotion, string name)
        {
            using (StreamWriter sw = new StreamWriter(".\\Result\\" + name + ".txt"))
                for (int i = 0; i < Emotion.Count; ++i)
                {
                    string tmp = "";
                    for (int j = 0; j < Emotion[i].Length; j += 2)
                    {
                        tmp += i + "," + ((int)Emotion[i][j]).ToString() + "," + Emotion[i][j + 1].ToString();
                        if (j < Emotion[i].Length - 2)
                            tmp += ";";
                    }
                    sw.WriteLine(tmp);
                }
        }
        static void WriterDouble(List<double[]> Emotion, string name)
        {
            using (StreamWriter sw = new StreamWriter(".\\Result\\" + name + ".txt"))
            {
                for (int i = 1; i <= Emotion.Count; ++i)
                {
                    string str = Emotion[i - 1][0].ToString();
                    for (int j = 2; j <= Emotion[i - 1].Length; ++j)
                        str += "," + Emotion[i - 1][j - 1].ToString();
                    sw.WriteLine(str);
                }
            }
        }
        static double[] NewArray(List<string> Emotion, string[] strarr, List<int> Doc, int N)
        {
            int[] intarr = new int[Emotion.Count];
            for (int i = 0; i < intarr.Length; ++i)
                intarr[i] = 0;
            int sum = 0;
            List<double> doublearr = new List<double>();
            foreach (string str in strarr)
            {
                int x = Emotion.IndexOf(str);
                if (x >= 0)
                {
                    intarr[x]++;
                    sum++;
                }
            }
            for (int i = 0; i < intarr.Length; ++i)
                if (intarr[i] > 0)// && Doc[i] > 0
                {
                    doublearr.Add(i);
                    //tf-idf
                    doublearr.Add((Math.Log((double)intarr[i])+1) * Math.Log((double)N / Doc[i]));
                    //doublearr.Add((double)intarr[i] / sum);
                }
            return doublearr.ToArray();
        }
        static void addtoarr(List<string[]> ls, List<string> bag, List<int> bagindex)
        {
            for (int i = 0; i < bag.Count; ++i)
                bagindex.Add(0);
            foreach (string[] strarr in ls)
            {
                List<int> add = new List<int>();
                foreach (string str in strarr)
                {
                    int index = bag.IndexOf(str);
                    if (index >= 0 && !add.Contains(index))
                    {
                        bagindex[index]++;
                        add.Add(index);
                    }
                }
            }
        }
        static void WriteWordList(List<string> ls, string name)
        {
            using (StreamWriter sw = new StreamWriter(".\\Result\\" + name + "Word.txt"))
            {
                sw.WriteLine(name);
                for (int i = 0; i < ls.Count; ++i)
                    sw.WriteLine("Index: " + i + " " + ls[i]);
            }
        }
        static void Digestion()
        {
            Console.WriteLine("step1");
            foreach (string[] strarr in EmotionStringA)
                foreach (string str in strarr)
                    if (!EmotionTermA.Contains(str))
                        EmotionTermA.Add(str);
            addtoarr(EmotionStringA, EmotionTermA, EmotionTermADoc);

            foreach (string[] strarr in EmotionStringB)
                foreach (string str in strarr)
                    if (!EmotionTermB.Contains(str))
                        EmotionTermB.Add(str);
            addtoarr(EmotionStringB, EmotionTermB, EmotionTermBDoc);

            Console.WriteLine("step2");
            foreach (string[] tmp in StringA)
                foreach (string tmp2 in tmp)
                    if (!AandB.Contains(tmp2))
                        AandB.Add(tmp2);

            foreach (string[] tmp in StringB)
                foreach (string tmp2 in tmp)
                    if (!AandB.Contains(tmp2))
                        AandB.Add(tmp2);
                    else if (!AorB.Contains(tmp2))
                        AorB.Add(tmp2);

            Console.WriteLine("length:" + AandB.Count + " " + AorB.Count);

            addtoarr(StringA, AandB, AAandBDoc);
            addtoarr(StringA, AorB, AAorBDoc);
            addtoarr(StringB, AandB, BAandBDoc);
            addtoarr(StringB, AorB, BAorBDoc);

            Console.WriteLine("step3");
            foreach (string[] strarr in EmotionStringA)
                EmotionFeatureA.Add(NewArray(EmotionTermA, strarr, EmotionTermADoc, EmotionStringA.Count));

            foreach (string[] strarr in EmotionStringB)
                EmotionFeatureB.Add(NewArray(EmotionTermB, strarr, EmotionTermBDoc, EmotionStringB.Count));

            foreach (string[] strarr in StringA)
            {
                FeatureAinAandB.Add(NewArray(AandB, strarr, AAandBDoc, EmotionStringA.Count));
                FeatureAinAorB.Add(NewArray(AorB, strarr, AAorBDoc, EmotionStringA.Count));
            }

            foreach (string[] strarr in StringB)
            {
                FeatureBinAandB.Add(NewArray(AandB, strarr, BAandBDoc, EmotionStringB.Count));
                FeatureBinAorB.Add(NewArray(AorB, strarr, BAorBDoc, EmotionStringB.Count));
            }

            Console.WriteLine("step4");
            using (StreamWriter sw = new StreamWriter(".\\Result\\Static.txt"))
            {
                sw.WriteLine("EmotionTermA");
                sw.WriteLine(EmotionTermA.Count);
                sw.WriteLine("EmotionTermB");
                sw.WriteLine(EmotionTermB.Count);
                sw.WriteLine("AandB");
                sw.WriteLine(AandB.Count);
                sw.WriteLine("AorB");
                sw.WriteLine(AorB.Count);
            }
            WriteWordList(EmotionTermA, "EmotionTermA");
            WriteWordList(EmotionTermB, "EmotionTermB");
            WriteWordList(AandB, "AandB");
            WriteWordList(AorB, "AorB");
        }
        static void ReadWords(string path, List<string> OutPut)
        {
            using (StreamReader sr = new StreamReader(".\\String\\" + path, Encoding.UTF8))
                while (!sr.EndOfStream)
                {
                    string tmp = sr.ReadLine().Trim();
                    if (!OutPut.Contains(tmp))
                        OutPut.Add(tmp);
                }
        }
        static bool IsChineseLetter(string input)
        {
            int code = 0;
            int chfrom = Convert.ToInt32("4e00", 16);
            int chend = Convert.ToInt32("9fff", 16);
            for (int i = 0; i < input.Length; i++)
                if (input != "")
                {
                    code = Char.ConvertToUtf32(input, i);
                    if (code >= chfrom && code <= chend)
                        continue;
                    else
                        return false;
                }
                else
                    return false;
            return true;
        }
        static void PushList(StreamReader sr, int EmotionsNum, int Total, string text, List<string[]> OutString, List<string[]> OutStringAll, List<double[]> OutPro, string Path, int[] votes)
        {
            //Number
            int[] emotions = new int[EmotionsNum];
            int sum = 0;
            for (int i = 0; i < EmotionsNum; ++i)
            {
                emotions[i] = int.Parse(sr.ReadLine().Split(':')[1]);
                sum += emotions[i];
                votes[i] += emotions[i];
            }
            double[] EmotionProbability = new double[EmotionsNum];
            for (int i = 0; i < EmotionsNum; ++i)
                EmotionProbability[i] = (double)emotions[i] / sum;
            OutPro.Add(EmotionProbability);

            //Text
            List<string> result = new List<string>();
            List<string> resultAll = new List<string>();
            foreach (string tmp in text.Split(Punctions))
            {
                if (!String.IsNullOrEmpty(tmp.Trim()))
                {
                    List<WordResult[]> tmpresult = ws.Segment(tmp.Trim());
                    for (int i = 1; i < tmpresult[0].Length - 1; ++i)
                    {
                        string str = tmpresult[0][i].sWord;
                        if (EmotionTerm.Contains(str))
                            result.Add(str);
                        if (!StopWords.Contains(str) && IsChineseLetter(str))
                            resultAll.Add(str);
                    }
                }
            }
            OutString.Add(result.ToArray());
            OutStringAll.Add(resultAll.ToArray());
        }
        static void ReadNews(string path, List<string[]> OutString, List<string[]> OutStringAll, List<double[]> OutPro, int Threshold, int EmotionsNum, int[] votes)
        {
            int count = 0;
            DirectoryInfo DI = new DirectoryInfo(path);
            if (EmotionsNum == 6)
                foreach (DirectoryInfo tmp in DI.GetDirectories())
                    foreach (DirectoryInfo tmp2 in tmp.GetDirectories())
                        foreach (FileInfo FI in tmp2.GetFiles())
                            using (StreamReader sr = new StreamReader(FI.FullName))
                            {
                                count++;
                                if (count % 100 == 0)
                                    Console.WriteLine("Num: " + count);
                                string text = "";
                                while (!sr.EndOfStream)
                                {
                                    string[] tmpstring = sr.ReadLine().Split(':');
                                    if (tmpstring[0] == "title")
                                        for (int i = 1; i < tmpstring.Length; ++i)
                                            text += tmpstring[i].Trim().Replace("（图）", "") + " ";
                                    else if (tmpstring[0] == "publish")
                                        for (int i = 1; i < tmpstring.Length; ++i)
                                            text += tmpstring[i].Trim() + " ";
                                    else if (tmpstring[0] == "Emotion")
                                    {
                                        if (int.Parse(tmpstring[1]) >= Threshold)
                                            PushList(sr, EmotionsNum, int.Parse(tmpstring[1]), text, OutString, OutStringAll, OutPro, FI.FullName, votes);
                                        break;
                                    }
                                }
                            }
            else if (EmotionsNum == 8)
                foreach (DirectoryInfo tmp in DI.GetDirectories())
                    foreach (FileInfo FI in tmp.GetFiles())
                        using (StreamReader sr = new StreamReader(FI.FullName))
                        {
                            count++;
                            if (count % 100 == 0)
                                Console.WriteLine("Num: " + count);
                            string text = "";
                            while (!sr.EndOfStream)
                            {
                                string[] tmpstring = sr.ReadLine().Split(':');
                                if (tmpstring[0] == "Title")
                                    for (int i = 1; i < tmpstring.Length; ++i)
                                        text += tmpstring[i].Trim() + " ";
                                else if (tmpstring[0] == "News content")
                                    for (int i = 1; i < tmpstring.Length; ++i)
                                        text += tmpstring[i].Trim() + " ";
                                else if (tmpstring[0] == "Total")
                                {
                                    if (int.Parse(tmpstring[1]) >= Threshold)
                                        PushList(sr, EmotionsNum, int.Parse(tmpstring[1]), text, OutString, OutStringAll, OutPro, FI.FullName, votes);
                                    break;
                                }
                            }
                        }
        }
    }
}
