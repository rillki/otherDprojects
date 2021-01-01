module eonium.hopfield;

class HopfieldNet {
	private double[][] trainingInput;
	private double[][] weight;
	private double threshold;
	
	this(double[][] trainingInput = null, double threshold = 0.0) {
		this.threshold = threshold;

		if(trainingInput !is null) {
			this.trainingInput = trainingInput;
		}
	}

	~this() {}

	void create(double[][] trainingInput = null, double threshold = 0.0) in {
		assert(trainingInput != null, "Error: trainingInput is null!");
	} do {
		this.trainingInput = trainingInput;
		this.threshold = threshold;
	}

	void learn() {
		weight.length = trainingInput[0].length;
		foreach(ref w; weight) { w.length = trainingInput[0].length; }

		foreach(i; 0..trainingInput[0].length) {
			foreach(j; 0..trainingInput[0].length) {
				double w = 0;
				if(i != j) {
					foreach(input; trainingInput) {
						w += input[i]*input[j];
					}
				}

				weight[i][j] = w;
			}
		}
	}

	double[][] recognize(double[][] input) in {
		assert(input[0].length == trainingInput[0].length, "Error: recognize data dimension != trainingInput dimensions!");
	} do {
		import eonium.std: dupl;
		double[][] output = dupl(input);

		foreach(ref o; output) {
			asynCorrection(o);
		}

		return output;
	}

	private void asynCorrection(double[] data) {
		import std.random: uniform;

		size_t iter = 0;
		size_t lastIter = 0;

		do {
			iter++;
			if(correction(data, uniform(0, data.length))) {
				lastIter = iter;
			}

		} while(iter - lastIter < 10*data.length);
	}

	private bool correction(double[] data, size_t index) {
		double sum = 0;
		double flag = 0;
		bool change = false;

		foreach(j, d; data) {
			sum += weight[index][j]*d;
		}

		if(sum != threshold) {
			if(sum < threshold) { flag = -1.0; }
			if(sum > threshold) { flag = 1.0; }
			if(flag != data[index]) {
				data[index] = flag;
				change = true;
			}
		}

		return change;
	}
}
































