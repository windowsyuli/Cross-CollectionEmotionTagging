using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
namespace SharpICTCLAS
{
    public class MainSeg
    {
        private WordSegment seg;
        public MainSeg()
        {
            InitPath();
        }
        private void InitPath()
        {
            seg = new WordSegment();
            seg.InitWordSegment("Data/");
        }
        public string[] Segment(string sentence)
        {
            List<string> result = new List<string>();
            List<WordResult[]> re = seg.Segment(sentence);
            for (int j = 1; j < re[0].Length - 1; j++)
            {
                result.Add(re[0][j].sWord);
            }
            return result.ToArray();
        }
        public string[,] SegmentAndPOS(string sentence)
        {
            List<string> words = new List<string>();
            List<string> poses = new List<string>();
            List<WordResult[]> re = seg.Segment(sentence);
            for (int j = 1; j < re[0].Length - 1; j++)
            {
                string word = re[0][j].sWord;
                string pos = Utility.GetPOSString(re[0][j].nPOS);
                words.Add(word);
                poses.Add(pos);
            }
            String[,] result = new string[2,words.Count];
            for (int j = 0; j < words.Count; j++)
            {
                result[0, j] = words[j];
            }
            for (int j = 0; j < poses.Count; j++)
            {
                result[1, j] = poses[j];
            }
            return result;
        }

    }
}
