package instanceTest;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.ArrayList;
import weka.core.Instances;
import weka.filters.Filter;
import weka.filters.supervised.attribute.AttributeSelection;

public class FilterTest {

	public static Instances m_instances = null;
	public static ArrayList<Integer> ArrayIndex = new ArrayList<Integer>();
	//public static String FileDir = "C:\\experiment\\ConsoleClassifier\\ConsoleClassifier\\bin\\Debug\\Result\\";
	public static String FileDir ="C:\\experiment\\ConsoleClassifier - 6v8\\ConsoleClassifier\\bin\\Debug\\Result\\";
	public static ArrayList<Integer> ai = new ArrayList<Integer>();
	public static ArrayList<Boolean> ab = new ArrayList<Boolean>();
	public static ArrayList<Integer> DeleteArrayA = new ArrayList<Integer>();
	public static ArrayList<Integer> DeleteArrayB = new ArrayList<Integer>();

	public static void getFileInstances(String fileName) throws Exception {
		FileReader frData = new FileReader(FileDir + fileName + ".arff");
		m_instances = new Instances(frData);
		m_instances.setClassIndex(m_instances.numAttributes() - 1);
	}

	public static void selectAttUseFilter() throws Exception {
		AttributeSelection filter = new AttributeSelection();
		weka.attributeSelection.ChiSquaredAttributeEval eval = new weka.attributeSelection.ChiSquaredAttributeEval();
		weka.attributeSelection.Ranker search = new weka.attributeSelection.Ranker();
		search.setThreshold(0);
		filter.setEvaluator(eval);
		filter.setSearch(search);
		filter.setInputFormat(m_instances);
		// System.out.println("number of instance attribute = "+
		// m_instances.numAttributes());
		Instances selectedIns = Filter.useFilter(m_instances, filter);
		// System.out.println("number of selected instance attribute = "+
		// selectedIns.numAttributes());
		for (int i = 0; i < selectedIns.numAttributes() - 1; ++i) {
			int tmp = Integer.parseInt(selectedIns.attribute(i).name());
			if (!ArrayIndex.contains(tmp))
				ArrayIndex.add(tmp);
		}
	}

	public static void remove() {
		ArrayIndex.removeAll(ArrayIndex);
	}

	public static void log() {
		if (ai.size() > 0) {
			String tmp = "";
			for (Integer i = 0; i < ai.size(); ++i) {
				tmp += ai.get(i);
				// if(ai.get(i)==1)
				// System.out.println(" 1");
				if (i != ai.size() - 1)
					tmp += ",";
			}
			System.out.println("Unselected: " + tmp);
			ai.removeAll(ai);
		} else {
			System.out.println("All selected!");
		}
	}

	public static void write(String filename, ArrayList<Integer> de)
			throws Exception {
		BufferedReader br = new BufferedReader(new FileReader(FileDir
				+ filename + ".txt"));
		BufferedWriter bw = new BufferedWriter(new FileWriter(FileDir
				+ filename + "Filter.txt"));
		String temp = null;
		temp = br.readLine();
		int dis = 0;
		while (temp != null) {
			if (de.contains(Integer.parseInt(temp.split(",")[0]))) {
				dis++;
				temp = br.readLine();
				continue;
			}
			String[] tmp2 = temp.split(";");
			ArrayList<String> ls = new ArrayList<String>();
			Integer x = 0;
			Integer y;
			Double value;
			for (String tmp3 : tmp2) {
				if (!tmp3.trim().equals("")) {
					String[] tmp4 = tmp3.split(",");
					x = Integer.parseInt(tmp4[0]);
					y = Integer.parseInt(tmp4[1]);
					value = Double.parseDouble(tmp4[2]);
					Integer index = ArrayIndex.indexOf(y);
					if (index >= 0) {
						ls.add((x + 1 - dis) + "," + (index + 1) + "," + value);
					}
				}
			}
			if (ls.size() > 0)
				for (Integer i = 0; i < ls.size(); i++) {
					bw.write(ls.get(i));
					bw.newLine();
				}
			else {
				if (!ai.contains(x))
					ai.add(x);
			}
			temp = br.readLine();
		}
		br.close();
		bw.close();
		if (ai.size() > 0) {
			String tmp = "";
			for (Integer i = 0; i < ai.size(); ++i) {
				tmp += ai.get(i);
				if (i != ai.size() - 1)
					tmp += ",";
			}
			System.out.println("Unselected: " + tmp);
			ai.removeAll(ai);
		} else {
			System.out.println("All selected!");
		}
	}

	public static boolean Check(String filename, ArrayList<Integer> de)
			throws Exception {
		BufferedReader br = new BufferedReader(new FileReader(FileDir
				+ filename + ".txt"));
		String temp = null;
		temp = br.readLine();
		ab.removeAll(ab);
		for (int i = 0; i < ArrayIndex.size(); ++i)
			ab.add(false);
		while (temp != null) {
			if (de.contains(Integer.parseInt(temp.split(",")[0]))) {
				temp = br.readLine();
				continue;
			}
			String[] tmp2 = temp.split(";");
			for (String tmp3 : tmp2) {
				if (!tmp3.trim().equals("")) {
					String[] tmp4 = tmp3.split(",");
					Integer y = Integer.parseInt(tmp4[1]);
					Integer index = ArrayIndex.indexOf(y);
					if (index >= 0)
						ab.set(index, true);
				}
			}
			temp = br.readLine();
		}
		Integer j = 0;
		for (Integer i = ArrayIndex.size() - 1; i >= 0; i--)
			if (!ab.get(i)) {
				j++;
				ArrayIndex.remove((int) i);
			}
		System.out.println("Remove " + j + " Items£¬ length: " + ArrayIndex.size());
		br.close();
		return true;
	}

	public static void NoModified(String filename, ArrayList<Integer> de,String filename1)
			throws Exception {
		BufferedReader br = new BufferedReader(new FileReader(FileDir
				+ filename + ".txt"));
		BufferedWriter bw = new BufferedWriter(new FileWriter(FileDir
				+ filename + "Filter.txt"));
		String temp = null;
		temp = br.readLine();
		int dis = 0;
		int line = 0, features = 0;
		int i=0;
		while (temp != null) {
			i++;
			//System.out.println(i);
			if (de.contains(Integer.parseInt(temp.split(",")[0]))) {
				dis++;
				temp = br.readLine();
				continue;
			}
			String[] tmp2 = temp.split(";");

			Integer x = 0;
			Integer y;
			Double value;
			for (String tmp3 : tmp2) {
				if (!tmp3.trim().equals("")) {
					String[] tmp4 = tmp3.split(",");
					x = Integer.parseInt(tmp4[0]);
					y = Integer.parseInt(tmp4[1]);
					value = Double.parseDouble(tmp4[2]);
					bw.write((x + 1 - dis) + "," + (y + 1) + "," + value);
					if (x + 1 - dis > line)
						line = x + 1 - dis;
					if (y + 1 > features)
						features = y + 1;
					bw.newLine();

				}
			}
			temp = br.readLine();
		}
		System.out.println(filename + " line: " + line + " features: "
				+ features);
		br.close();
		bw.close();
		
	}
	public static void writepro(String filename,ArrayList<Integer> de) throws Exception {
		BufferedReader br2 = new BufferedReader(new FileReader(FileDir
				+ filename + ".txt"));
		BufferedWriter bw2 = new BufferedWriter(new FileWriter(FileDir
				+ filename + "Filter.txt"));
		String temp = br2.readLine();
		Integer i = 0;
		while (temp != null) {
			// System.out.println(i);
			if (!de.contains((Integer) i)) {
				bw2.write(temp);
				bw2.newLine();
			}
			i++;
			temp = br2.readLine();
		}
		br2.close();
		bw2.close();
	}
	public static void check2(String filename)throws Exception{
		BufferedReader br = new BufferedReader(new FileReader(FileDir
				+ filename + "Filter.txt"));
		String temp = br.readLine();
		Integer i = 1;
		while (temp != null) {
			Integer in = Integer.parseInt(temp.split(",")[0]);
			if (in - i == 1)
				i = in;
			else if (in - i < 0)
		 		System.err.println("error!");
			else if (in - i > 1) {
				System.err.println("Check2: Unselected " + (i + 1) + " !");
				i = in;
			}
			temp = br.readLine();
		}
		System.out.println("Check2 complete!");
		br.close();
	}

	public static void main(String[] args) throws Exception {
		//Integer[] IB2={307,488,1117,1208,2153,2629,3538,3772,4992,5052,6336,100,176,332,500,510,733,946,1189,2159,2276,2384,2837,2935,3143,3169,3222,3413,3495,3523,3671,3776,3830,4079,4339,4345,4503,4581,4853,4875,5311,5497,5525,5537,5735,5814,5850,6290,6372,6639,6714,6797,7132,7296,7440};
		//for (int i = 0; i < IB2.length; i++) {
		//	if(!DeleteArrayB.contains(IB2[i]))
		//			DeleteArrayB.add(IB2[i]);
		//}
		String name = "EmotionFeatureA";
		getFileInstances(name);
		selectAttUseFilter();
		Check("EmotionFeatureA",DeleteArrayA);
		System.out.println("EmotionFeatureA " + "ArrayLength" + ":"+ ArrayIndex.size());
		write(name,DeleteArrayA);
		check2("EmotionFeatureA");

		remove();
		name = "EmotionFeatureB";
		getFileInstances(name);
		selectAttUseFilter();
		Check("EmotionFeatureB",DeleteArrayB);
		System.out.println("EmotionFeatureB " + "ArrayLength" + ":"+ ArrayIndex.size());
		write(name,DeleteArrayB);
		check2("EmotionFeatureB");
		
		writepro("EmotionProA",DeleteArrayA);

		writepro("EmotionProB",DeleteArrayB);

//		System.out.println("EmotionFeatureA");
//		NoModified("EmotionFeatureA", DeleteArrayA,"EmotionProA");
//		System.out.println("EmotionFeatureB");
//		NoModified("EmotionFeatureB", DeleteArrayB,"EmotionProB");

		remove();
		getFileInstances("FeatureAinAandB");
		selectAttUseFilter();
		getFileInstances("FeatureBinAandB");
		selectAttUseFilter();
		Check("FeatureAinAandB", DeleteArrayA);
		Check("FeatureBinAandB", DeleteArrayB);
		System.out.println("FeatureAandB " + "ArrayLength" + ":" + ArrayIndex.size());
		write("FeatureAinAandB", DeleteArrayA);
		write("FeatureBinAandB", DeleteArrayB);
		check2("FeatureAinAandB");
		check2("FeatureBinAandB");

		remove();
		getFileInstances("FeatureAinAorB");
		selectAttUseFilter();
		getFileInstances("FeatureBinAorB");
		selectAttUseFilter();
		Check("FeatureAinAorB", DeleteArrayA);
		Check("FeatureBinAorB", DeleteArrayB);
		System.out.println("FeatureAorB " + "ArrayLength" + ":" + ArrayIndex.size());
		write("FeatureAinAorB", DeleteArrayA);
		write("FeatureBinAorB", DeleteArrayB);
		check2("FeatureAinAorB");
		check2("FeatureBinAorB");

		System.out.println("complete!");
	}
}
