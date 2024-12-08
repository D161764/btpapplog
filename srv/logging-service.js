const cds = require('@sap/cds')

module.exports = class LoggingService extends cds.ApplicationService {
  async init() {
    const { 
      IntegrationFlows, 
      FlowExecutions, 
      ExecutionSteps, 
      ErrorLogs 
    } = this.entities

    this.before('CREATE', 'FlowExecutions', (req) => {
      req.data.startTime = new Date()
      req.data.status = 'RUNNING'
    })

    this.on('startExecution', async (req) => {
      const { flowId, messageId } = req.data
      const execution = await INSERT.into(FlowExecutions).entries({
        flow_ID: flowId,
        messageId: messageId,
        status: 'RUNNING',
        startTime: new Date()
      })
      return execution.ID
    })

    this.on('completeExecution', async (req) => {
      const { executionId, status } = req.data
      const endTime = new Date()
      
      await UPDATE(FlowExecutions)
        .set({
          status: status,
          endTime: endTime
        })
        .where({ ID: executionId })
    })

    this.on('logStep', async (req) => {
      const { executionId, stepName, payload } = req.data
      const step = await INSERT.into(ExecutionSteps).entries({
        execution_ID: executionId,
        stepName: stepName,
        startTime: new Date(),
        inputPayload: payload,
        status: 'PROCESSING'
      })
      return step.ID
    })

    this.on('logError', async (req) => {
      const { executionId, errorCode, message } = req.data
      await INSERT.into(ErrorLogs).entries({
        execution_ID: executionId,
        timestamp: new Date(),
        errorCode: errorCode,
        errorMessage: message,
        severity: 'ERROR'
      })
    })

    await super.init()
  }
}
