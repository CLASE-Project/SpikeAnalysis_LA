import numpy as np
def bipolarReference(signalMatrix, forwardOrBackward):
    '''
    This function will take a matrix and return the bipolar referenced version.
    Because python modifies by reference, you will no longer have the original signal you passed in after making this transformation, so be careful!!!
​
    bipolarReference(A, 'forward') - Will do forward bipolar referencing, where the end electrode (with highest idx) will not have a partner to reference against.
    bipolarReference(A, 'backward') - Will do backward bipolar referencing, where the beginning electrode (with lowest idx) will not have a partner to reference against.
    '''
    # Forward reference (Meaning 1-2 -> 1, 2-3 -> 2, etc.)
    channels, samples = np.shape(signalMatrix)
    assert channels < samples, f"This function assumes that channels are the rows, and samples are columns. Try transposing your data first."
    if forwardOrBackward == 'forward':
        for idx in range(channels):
            try:
                signalMatrix[idx, :] = signalMatrix[idx, :] - signalMatrix[idx+1, :]
            except:
                signalMatrix[idx, :] = signalMatrix[idx, :]
    else:
        idx = channels
        while(idx >= 0):
            try:
                signalMatrix[idx, :] = signalMatrix[idx, :] - signalMatrix[idx-1, :]
            except:
                signalMatrix[idx, :] = signalMatrix[idx, :]
        idx = idx - 1