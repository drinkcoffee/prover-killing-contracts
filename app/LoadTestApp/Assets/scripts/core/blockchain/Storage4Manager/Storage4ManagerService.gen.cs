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
using LoadTest.Storage4Manager.ContractDefinition;

namespace LoadTest.Storage4Manager
{
    public partial class Storage4ManagerService: Storage4ManagerServiceBase
    {
        public static Task<TransactionReceipt> DeployContractAndWaitForReceiptAsync(Nethereum.Web3.IWeb3 web3, Storage4ManagerDeployment storage4ManagerDeployment, CancellationTokenSource cancellationTokenSource = null)
        {
            return web3.Eth.GetContractDeploymentHandler<Storage4ManagerDeployment>().SendRequestAndWaitForReceiptAsync(storage4ManagerDeployment, cancellationTokenSource);
        }

        public static Task<string> DeployContractAsync(Nethereum.Web3.IWeb3 web3, Storage4ManagerDeployment storage4ManagerDeployment)
        {
            return web3.Eth.GetContractDeploymentHandler<Storage4ManagerDeployment>().SendRequestAsync(storage4ManagerDeployment);
        }

        public static async Task<Storage4ManagerService> DeployContractAndGetServiceAsync(Nethereum.Web3.IWeb3 web3, Storage4ManagerDeployment storage4ManagerDeployment, CancellationTokenSource cancellationTokenSource = null)
        {
            var receipt = await DeployContractAndWaitForReceiptAsync(web3, storage4ManagerDeployment, cancellationTokenSource);
            return new Storage4ManagerService(web3, receipt.ContractAddress);
        }

        public Storage4ManagerService(Nethereum.Web3.IWeb3 web3, string contractAddress) : base(web3, contractAddress)
        {
        }

    }


    public partial class Storage4ManagerServiceBase: ContractWeb3ServiceBase
    {

        public Storage4ManagerServiceBase(Nethereum.Web3.IWeb3 web3, string contractAddress) : base(web3, contractAddress)
        {
        }

        public virtual Task<string> DeployRequestAsync(DeployFunction deployFunction)
        {
             return ContractHandler.SendRequestAsync(deployFunction);
        }

        public virtual Task<TransactionReceipt> DeployRequestAndWaitForReceiptAsync(DeployFunction deployFunction, CancellationTokenSource cancellationToken = null)
        {
             return ContractHandler.SendRequestAndWaitForReceiptAsync(deployFunction, cancellationToken);
        }

        public virtual Task<string> DeployRequestAsync(BigInteger iteration)
        {
            var deployFunction = new DeployFunction();
                deployFunction.Iteration = iteration;
            
             return ContractHandler.SendRequestAsync(deployFunction);
        }

        public virtual Task<TransactionReceipt> DeployRequestAndWaitForReceiptAsync(BigInteger iteration, CancellationTokenSource cancellationToken = null)
        {
            var deployFunction = new DeployFunction();
                deployFunction.Iteration = iteration;
            
             return ContractHandler.SendRequestAndWaitForReceiptAsync(deployFunction, cancellationToken);
        }

        public Task<List<string>> GetContractsQueryAsync(GetContractsFunction getContractsFunction, BlockParameter blockParameter = null)
        {
            return ContractHandler.QueryAsync<GetContractsFunction, List<string>>(getContractsFunction, blockParameter);
        }

        
        public virtual Task<List<string>> GetContractsQueryAsync(BigInteger ofs, BigInteger len, BlockParameter blockParameter = null)
        {
            var getContractsFunction = new GetContractsFunction();
                getContractsFunction.Ofs = ofs;
                getContractsFunction.Len = len;
            
            return ContractHandler.QueryAsync<GetContractsFunction, List<string>>(getContractsFunction, blockParameter);
        }

        public Task<BigInteger> GetContractsLengthQueryAsync(GetContractsLengthFunction getContractsLengthFunction, BlockParameter blockParameter = null)
        {
            return ContractHandler.QueryAsync<GetContractsLengthFunction, BigInteger>(getContractsLengthFunction, blockParameter);
        }

        
        public virtual Task<BigInteger> GetContractsLengthQueryAsync(BlockParameter blockParameter = null)
        {
            return ContractHandler.QueryAsync<GetContractsLengthFunction, BigInteger>(null, blockParameter);
        }

        public virtual Task<string> LoadColdRequestAsync(LoadColdFunction loadColdFunction)
        {
             return ContractHandler.SendRequestAsync(loadColdFunction);
        }

        public virtual Task<TransactionReceipt> LoadColdRequestAndWaitForReceiptAsync(LoadColdFunction loadColdFunction, CancellationTokenSource cancellationToken = null)
        {
             return ContractHandler.SendRequestAndWaitForReceiptAsync(loadColdFunction, cancellationToken);
        }

        public virtual Task<string> LoadColdRequestAsync(BigInteger iteration)
        {
            var loadColdFunction = new LoadColdFunction();
                loadColdFunction.Iteration = iteration;
            
             return ContractHandler.SendRequestAsync(loadColdFunction);
        }

        public virtual Task<TransactionReceipt> LoadColdRequestAndWaitForReceiptAsync(BigInteger iteration, CancellationTokenSource cancellationToken = null)
        {
            var loadColdFunction = new LoadColdFunction();
                loadColdFunction.Iteration = iteration;
            
             return ContractHandler.SendRequestAndWaitForReceiptAsync(loadColdFunction, cancellationToken);
        }

        public virtual Task<string> StoreColdRequestAsync(StoreColdFunction storeColdFunction)
        {
             return ContractHandler.SendRequestAsync(storeColdFunction);
        }

        public virtual Task<TransactionReceipt> StoreColdRequestAndWaitForReceiptAsync(StoreColdFunction storeColdFunction, CancellationTokenSource cancellationToken = null)
        {
             return ContractHandler.SendRequestAndWaitForReceiptAsync(storeColdFunction, cancellationToken);
        }

        public virtual Task<string> StoreColdRequestAsync(BigInteger iteration, BigInteger val)
        {
            var storeColdFunction = new StoreColdFunction();
                storeColdFunction.Iteration = iteration;
                storeColdFunction.Val = val;
            
             return ContractHandler.SendRequestAsync(storeColdFunction);
        }

        public virtual Task<TransactionReceipt> StoreColdRequestAndWaitForReceiptAsync(BigInteger iteration, BigInteger val, CancellationTokenSource cancellationToken = null)
        {
            var storeColdFunction = new StoreColdFunction();
                storeColdFunction.Iteration = iteration;
                storeColdFunction.Val = val;
            
             return ContractHandler.SendRequestAndWaitForReceiptAsync(storeColdFunction, cancellationToken);
        }

        public override List<Type> GetAllFunctionTypes()
        {
            return new List<Type>
            {
                typeof(DeployFunction),
                typeof(GetContractsFunction),
                typeof(GetContractsLengthFunction),
                typeof(LoadColdFunction),
                typeof(StoreColdFunction)
            };
        }

        public override List<Type> GetAllEventTypes()
        {
            return new List<Type>
            {
                typeof(FinalResultEventDTO)
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
