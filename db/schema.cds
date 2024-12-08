namespace com.sap.cpi.logging;

using { managed, cuid } from '@sap/cds/common';

entity IntegrationFlows : managed, cuid {
  name        : String(255) @title: 'Integration Flow Name';
  version     : String(50)  @title: 'Version';
  description : String(1000);
  status      : String(20)  @title: 'Status';
  companyCode : String(4)   @title: 'Company Code';
  executions  : Association to many FlowExecutions on executions.flow = $self;
}

entity FlowExecutions : cuid {
  flow            : Association to IntegrationFlows;
  startTime       : Timestamp  @title: 'Start Time';
  endTime         : Timestamp  @title: 'End Time';
  status          : String(20) @title: 'Execution Status';
  messageId       : String     @title: 'Message ID';
  duration        : Integer    @title: 'Duration (ms)';
  steps           : Association to many ExecutionSteps on steps.execution = $self;
  errors          : Association to many ErrorLogs on errors.execution = $self;
}

entity ExecutionSteps : cuid {
  execution    : Association to FlowExecutions;
  stepName     : String     @title: 'Step Name';
  stepType     : String     @title: 'Step Type';
  startTime    : Timestamp  @title: 'Start Time';
  endTime      : Timestamp  @title: 'End Time';
  status       : String(20) @title: 'Status';
  inputPayload : LargeString @title: 'Input Payload';
  outputPayload: LargeString @title: 'Output Payload';
}

entity ErrorLogs : cuid {
  execution    : Association to FlowExecutions;
  timestamp    : Timestamp   @title: 'Timestamp';
  errorCode    : String(50)  @title: 'Error Code';
  errorMessage : String(1000)@title: 'Error Message';
  stackTrace   : LargeString @title: 'Stack Trace';
  severity     : String(20)  @title: 'Severity';
  category     : String(50)  @title: 'Category';
}

@cds.persistence.skip
entity RetentionPolicies {
  key id           : UUID;
  dataType        : String(50)  @title: 'Data Type';
  retentionPeriod : Integer     @title: 'Retention Period (days)';
  isActive        : Boolean     @title: 'Active';
}
