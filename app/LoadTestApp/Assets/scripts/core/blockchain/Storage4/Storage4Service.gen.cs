using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Numerics;
using Nethereum.Hex.HexTypes;
using Nethereum.ABI.FunctionEncoding.Attributes;
using Nethereum.Web3;
using Nethereum.RPC.Eth.DTOs;
using Nethereum.Contracts.CQS;
using Nethereum.Contracts.ContractHandlers;
using Nethereum.Contracts;
using System.Threading;
using LoadTest.Storage4.ContractDefinition;

namespace LoadTest.Storage4
{
    public partial class Storage4Service: Storage4ServiceBase
    {
        public static Task<TransactionReceipt> DeployContractAndWaitForReceiptAsync(Nethereum.Web3.IWeb3 web3, Storage4Deployment storage4Deployment, CancellationTokenSource cancellationTokenSource = null)
        {
            return web3.Eth.GetContractDeploymentHandler<Storage4Deployment>().SendRequestAndWaitForReceiptAsync(storage4Deployment, cancellationTokenSource);
        }

        public static Task<string> DeployContractAsync(Nethereum.Web3.IWeb3 web3, Storage4Deployment storage4Deployment)
        {
            return web3.Eth.GetContractDeploymentHandler<Storage4Deployment>().SendRequestAsync(storage4Deployment);
        }

        public static async Task<Storage4Service> DeployContractAndGetServiceAsync(Nethereum.Web3.IWeb3 web3, Storage4Deployment storage4Deployment, CancellationTokenSource cancellationTokenSource = null)
        {
            var receipt = await DeployContractAndWaitForReceiptAsync(web3, storage4Deployment, cancellationTokenSource);
            return new Storage4Service(web3, receipt.ContractAddress);
        }

        public Storage4Service(Nethereum.Web3.IWeb3 web3, string contractAddress) : base(web3, contractAddress)
        {
        }

    }


    public partial class Storage4ServiceBase: ContractWeb3ServiceBase
    {

        public Storage4ServiceBase(Nethereum.Web3.IWeb3 web3, string contractAddress) : base(web3, contractAddress)
        {
        }

        public Task<BigInteger> FillOfsQueryAsync(FillOfsFunction fillOfsFunction, BlockParameter blockParameter = null)
        {
            return ContractHandler.QueryAsync<FillOfsFunction, BigInteger>(fillOfsFunction, blockParameter);
        }

        
        public virtual Task<BigInteger> FillOfsQueryAsync(BlockParameter blockParameter = null)
        {
            return ContractHandler.QueryAsync<FillOfsFunction, BigInteger>(null, blockParameter);
        }

        public virtual Task<string> FillUpStorageRequestAsync(FillUpStorageFunction fillUpStorageFunction)
        {
             return ContractHandler.SendRequestAsync(fillUpStorageFunction);
        }

        public virtual Task<string> FillUpStorageRequestAsync()
        {
             return ContractHandler.SendRequestAsync<FillUpStorageFunction>();
        }

        public virtual Task<TransactionReceipt> FillUpStorageRequestAndWaitForReceiptAsync(FillUpStorageFunction fillUpStorageFunction, CancellationTokenSource cancellationToken = null)
        {
             return ContractHandler.SendRequestAndWaitForReceiptAsync(fillUpStorageFunction, cancellationToken);
        }

        public virtual Task<TransactionReceipt> FillUpStorageRequestAndWaitForReceiptAsync(CancellationTokenSource cancellationToken = null)
        {
             return ContractHandler.SendRequestAndWaitForReceiptAsync<FillUpStorageFunction>(null, cancellationToken);
        }

        public Task<BigInteger> LoadColdQueryAsync(LoadColdFunction loadColdFunction, BlockParameter blockParameter = null)
        {
            return ContractHandler.QueryAsync<LoadColdFunction, BigInteger>(loadColdFunction, blockParameter);
        }

        
        public virtual Task<BigInteger> LoadColdQueryAsync(BlockParameter blockParameter = null)
        {
            return ContractHandler.QueryAsync<LoadColdFunction, BigInteger>(null, blockParameter);
        }

        public virtual Task<string> StoreColdRequestAsync(StoreColdFunction storeColdFunction)
        {
             return ContractHandler.SendRequestAsync(storeColdFunction);
        }

        public virtual Task<TransactionReceipt> StoreColdRequestAndWaitForReceiptAsync(StoreColdFunction storeColdFunction, CancellationTokenSource cancellationToken = null)
        {
             return ContractHandler.SendRequestAndWaitForReceiptAsync(storeColdFunction, cancellationToken);
        }

        public virtual Task<string> StoreColdRequestAsync(BigInteger val)
        {
            var storeColdFunction = new StoreColdFunction();
                storeColdFunction.Val = val;
            
             return ContractHandler.SendRequestAsync(storeColdFunction);
        }

        public virtual Task<TransactionReceipt> StoreColdRequestAndWaitForReceiptAsync(BigInteger val, CancellationTokenSource cancellationToken = null)
        {
            var storeColdFunction = new StoreColdFunction();
                storeColdFunction.Val = val;
            
             return ContractHandler.SendRequestAndWaitForReceiptAsync(storeColdFunction, cancellationToken);
        }

        public override List<Type> GetAllFunctionTypes()
        {
            return new List<Type>
            {
                typeof(FillOfsFunction),
                typeof(FillUpStorageFunction),
                typeof(LoadColdFunction),
                typeof(StoreColdFunction)
            };
        }

        public override List<Type> GetAllEventTypes()
        {
            return new List<Type>
            {

            };
        }

        public override List<Type> GetAllErrorTypes()
        {
            return new List<Type>
            {

            };
        }
    }
}
