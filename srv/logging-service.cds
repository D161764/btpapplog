using { com.sap.cpi.logging as db } from '../db/schema';

@path: 'logging'
service LoggingService @(requires: 'authenticated-user') {
  entity IntegrationFlows as projection on db.IntegrationFlows;
  entity FlowExecutions as projection on db.FlowExecutions;
  entity ExecutionSteps as projection on db.ExecutionSteps;
  entity ErrorLogs as projection on db.ErrorLogs;
  
  @readonly
  entity RetentionPolicies as projection on db.RetentionPolicies;

  // Custom actions
  action startExecution(flowId: UUID, messageId: String) returns UUID;
  action completeExecution(executionId: UUID, status: String);
  action logStep(executionId: UUID, stepName: String, payload: String) returns UUID;
  action logError(executionId: UUID, errorCode: String, message: String);
}
