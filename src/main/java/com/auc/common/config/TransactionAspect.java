package com.auc.common.config;

import java.util.Collections;
import java.util.HashMap;

import org.springframework.aop.Advisor;
import org.springframework.aop.aspectj.AspectJExpressionPointcut;
import org.springframework.aop.support.DefaultPointcutAdvisor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.interceptor.MatchAlwaysTransactionAttributeSource;
import org.springframework.transaction.interceptor.RollbackRuleAttribute;
import org.springframework.transaction.interceptor.RuleBasedTransactionAttribute;
import org.springframework.transaction.interceptor.TransactionInterceptor;

@Configuration
public class TransactionAspect {
	
	@Autowired
	PlatformTransactionManager transactionManager;
	
	@SuppressWarnings("deprecation")
	@Bean
	public TransactionInterceptor transactionAdvice() {

		MatchAlwaysTransactionAttributeSource attributeSource = new MatchAlwaysTransactionAttributeSource();
		RuleBasedTransactionAttribute txAttribute = new RuleBasedTransactionAttribute();
		txAttribute.setName("*");
		txAttribute.setRollbackRules(Collections.singletonList(new RollbackRuleAttribute(Exception.class)));
		
		attributeSource.setTransactionAttribute(txAttribute);
		
		//txAttribute.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		
//		HashMap<String, TransactionAttribute> txMethods = new HashMap<String, TransactionAttribute>();
//		txMethods.put("*", txAttribute);		
		//NameMatchTransactionAttributeSource txAttributeSource = new NameMatchTransactionAttributeSource();
//		txAttributeSource.setNameMap(txMethods);
		
		return new TransactionInterceptor(transactionManager, attributeSource);
	}

	@Bean
	public Advisor transactionAdviceAdvisor() {
		AspectJExpressionPointcut pointcut = new AspectJExpressionPointcut();
		pointcut.setExpression("execution(* *..*service..*.*(..))");
		return new DefaultPointcutAdvisor(pointcut, transactionAdvice());
	}

}
