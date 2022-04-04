import random

class InvalidLottoError(RuntimeError):
    """Error generated if an invalid lotto input is given."""

def roll(r = 40, n = 6):
    """Computes a random set of non duplicated lotto numbers.
    
    Args:
        r: A positive number representing the max number.
        n: A positive number representing the set length.

    Raises:
        InvalidLottoError: If any of the inputs are invalid

    Returns:
        Sorted array of lotto numbers.
    """

    if r < 0:
        raise InvalidLottoError(f"r is less than zero: {r}")
    elif n < 0:
        raise InvalidLottoError(f"n is less than zero: {n}")

    lottoNumbers = random.sample(range(r), n)
    lottoNumbers = [x+1 for x in lottoNumbers]
    lottoNumbers.sort()
    
    return lottoNumbers