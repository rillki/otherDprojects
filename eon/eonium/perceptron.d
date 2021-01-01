module eonium.perceptron;

class Perceptron {
	import eonium.std: dupl;
	import std.stdio: writeln;

	private double[][] trainingInput;
	private double[] expectedOutput;
	private double[] output;
	private double[] weights;
	private double[] error;
	private double[] adjustments;

	private int nepoch;
	private double alpha;
	private double bias;

	this(double[][] trainingInput = null, double[] expectedOutput = null, int nepoch = 100, double alpha = 1.0, double bias = 0.0) in {
		assert(trainingInput.length == expectedOutput.length, "Error: input.length != expectedOutput.length.");
	} do {
		if(trainingInput !is null) {
			this.trainingInput = dupl(trainingInput);

			this.weights.length = this.trainingInput[0].length;
			this.output.length = this.trainingInput.length;
			this.adjustments.length = this.trainingInput.length+1;
			this.error.length = this.trainingInput.length+1;

			foreach(ref w; weights) { w = 0; }
			foreach(ref o; output) { o = 0; }
			foreach(ref adj; adjustments) { adj = 0; }
			foreach(ref err; error) { err = 0; }
		}

		if(expectedOutput !is null) {
			this.expectedOutput = expectedOutput.dup;
		}

		this.nepoch = nepoch;
		this.alpha = alpha;
		this.bias = bias;
	}

	void create(double[][] trainingInput, double[] expectedOutput, int nepoch = 100, double alpha = 1, double bias = 0) {
		this.trainingInput = dupl(trainingInput);
		this.expectedOutput = expectedOutput.dup;
		this.nepoch = nepoch;
		this.alpha = alpha;
		this.bias = bias;

		this.weights.length = this.trainingInput[0].length;
		this.output.length = this.trainingInput.length;
		this.error.length = this.trainingInput.length+1;
		this.adjustments.length = this.trainingInput.length+1;

		foreach(ref w; weights) { w = 0; }
		foreach(ref err; error) { err = 0; }
		foreach(ref o; output) { o = 0; }
		foreach(ref adj; adjustments) { adj = 0; }
	}

	void setWeights(double[] weights) {
		this.weights = weights;
	}

	void setEpochs(const(int) nepoch) {
		this.nepoch = nepoch;
	}

	void setAlpha(const(double) alpha) {
		this.alpha = alpha;
	}

	void setBias(const(double) bias) {
		this.bias = bias;
	}

	double[] getTrainedPredictedOutput(const(bool) round = false) {
		if(round) {
			import std.math: round;
			foreach(ref o; output) {
				o = round(o);
			}
		}

		return output.dup;
	}

	void learn(const(bool) verbose = false) {
		foreach(epoch; 0..nepoch) {
			// input layer
			auto inputLayer = trainingInput;

			// predict output
			foreach(i, ref layer; inputLayer) {
				output[i] = sigmoid(dotProduct(layer, weights)) + bias;
			}

			// calculating errors
			foreach(i, t; expectedOutput) {
		    	error[i] = alpha*(t - output[i]);
		    }

		    // making adjustments
		    for(size_t i = 0; i < error.length-1; i++) {
		    	error[i] *= (output[i]*(1 - output[i]));
		    }

		    foreach(i, ref layer; inputLayer) {
		    	adjustments[i] = dotProduct(layer, error);
		    }

		    foreach(i, ref w; weights) {
		    	w += adjustments[i];
		    }

			// print progress
			if(verbose) { 
				writeln;
				writeln("Epoch: ", epoch);
				writeln("Predicted output:\n", output); 
				writeln("Original weights:\n", weights); 
				writeln("Error:\n", error); 
				writeln("Adjustment values:\n", adjustments); 
				writeln("Adjusted weights:\n", weights); 
				writeln;
			}
		}
	}

	double[] predict(const(double[][]) input, bool round = false) const {
		double[] outData; outData.length = input.length;
		foreach(i, layer; input) {
			outData[i] = sigmoid(dotProduct(layer, weights));
		}

		if(round) {
			import std.math: round;
			foreach(ref o; outData) {
				o = round(o);
			}
		}

		return outData;
	}

	private double dotProduct(const(double[]) x,const(double[]) y) const {
		size_t length = ((x.length >= y.length) ? (y.length) : (x.length));
		double dot = 0;
		foreach(i; 0..length) {
			dot += x[i]*y[i];
		}

		return dot;
	}

	private double sigmoid(const(double) x) const {
		import std.math: exp;
		return (1.0/(1.0 + exp(-x)));
	}
}












