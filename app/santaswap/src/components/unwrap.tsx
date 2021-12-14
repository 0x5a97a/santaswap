import { useEthers } from "@usedapp/core";
import { useClaims, useNiceList, useUnwrapGift } from "../hooks/contracts";

const Unwrap = () => {
  const { account } = useEthers();
  const { onList } = useNiceList(account || "");
  const { claimed } = useClaims(account || "");
  const {
    state: { status, errorMessage },
    send: sendUnwrapGift,
  } = useUnwrapGift();

  const unwrapGift = async () => {
    await sendUnwrapGift();
  };

  return (
    <div className="flex flex-col mb-8">
      <p className="mb-6 text-center font-semibold">🎁 Santa has visited. 🎁</p>
      {claimed ? (
        <div className="text-center">
          <p>You have unwrapped your gift.</p>
          <p>Merry Christmas!</p>
        </div>
      ) : (
        <>
          {onList ? (
            <button
              className="bg-gradient-to-tr from-red-800 to-red-600 hover:from-red-900 hover:to-red-800 text-white font-semibold py-2 px-4 rounded-lg shadow"
              disabled={status === "Mining"}
              onClick={unwrapGift}
            >
              Unwrap a gift
            </button>
          ) : (
            "This address is not on the Nice List."
          )}
          <div>{errorMessage}</div>
        </>
      )}
    </div>
  );
};

export default Unwrap;
