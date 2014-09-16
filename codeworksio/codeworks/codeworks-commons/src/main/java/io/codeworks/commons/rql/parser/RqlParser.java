// Generated from Rql.g4 by ANTLR 4.2
package io.codeworks.commons.rql.parser;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class RqlParser extends Parser {
	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__32=1, T__31=2, T__30=3, T__29=4, T__28=5, T__27=6, T__26=7, T__25=8, 
		T__24=9, T__23=10, T__22=11, T__21=12, T__20=13, T__19=14, T__18=15, T__17=16, 
		T__16=17, T__15=18, T__14=19, T__13=20, T__12=21, T__11=22, T__10=23, 
		T__9=24, T__8=25, T__7=26, T__6=27, T__5=28, T__4=29, T__3=30, T__2=31, 
		T__1=32, T__0=33, IDENTIFIER=34, VALUE=35, SIGN=36, WS=37;
	public static final String[] tokenNames = {
		"<INVALID>", "'&'", "'in'", "','", "'or'", "'('", "'=gt='", "'<'", "'!='", 
		"'<='", "'ge'", "'page'", "'and'", "'sort'", "'asc'", "'eq'", "'lt'", 
		"'=le='", "'le'", "'limit'", "')'", "'=ge='", "'gt'", "'ne'", "'='", "'desc'", 
		"';'", "'&&'", "'||'", "'>'", "'=='", "'=lt='", "'>='", "'|'", "IDENTIFIER", 
		"VALUE", "SIGN", "WS"
	};
	public static final int
		RULE_query = 0, RULE_cond = 1, RULE_op = 2, RULE_eq = 3, RULE_ne = 4, 
		RULE_gt = 5, RULE_ge = 6, RULE_lt = 7, RULE_le = 8, RULE_in = 9, RULE_order = 10, 
		RULE_range = 11;
	public static final String[] ruleNames = {
		"query", "cond", "op", "eq", "ne", "gt", "ge", "lt", "le", "in", "order", 
		"range"
	};

	@Override
	public String getGrammarFileName() { return "Rql.g4"; }

	@Override
	public String[] getTokenNames() { return tokenNames; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public RqlParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class QueryContext extends ParserRuleContext {
		public OrderContext order() {
			return getRuleContext(OrderContext.class,0);
		}
		public RangeContext range() {
			return getRuleContext(RangeContext.class,0);
		}
		public CondContext cond() {
			return getRuleContext(CondContext.class,0);
		}
		public QueryContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_query; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).enterQuery(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).exitQuery(this);
		}
	}

	public final QueryContext query() throws RecognitionException {
		QueryContext _localctx = new QueryContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_query);
		int _la;
		try {
			setState(39);
			switch ( getInterpreter().adaptivePredict(_input,0,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(24); cond(0);
				}
				break;

			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(25); cond(0);
				setState(26);
				_la = _input.LA(1);
				if ( !(_la==3 || _la==26) ) {
				_errHandler.recoverInline(this);
				}
				consume();
				setState(27); order();
				}
				break;

			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(29); cond(0);
				setState(30);
				_la = _input.LA(1);
				if ( !(_la==3 || _la==26) ) {
				_errHandler.recoverInline(this);
				}
				consume();
				setState(31); range();
				}
				break;

			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(33); cond(0);
				setState(34);
				_la = _input.LA(1);
				if ( !(_la==3 || _la==26) ) {
				_errHandler.recoverInline(this);
				}
				consume();
				setState(35); order();
				setState(36);
				_la = _input.LA(1);
				if ( !(_la==3 || _la==26) ) {
				_errHandler.recoverInline(this);
				}
				consume();
				setState(37); range();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CondContext extends ParserRuleContext {
		public CondContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_cond; }
	 
		public CondContext() { }
		public void copyFrom(CondContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class OrContext extends CondContext {
		public CondContext cond(int i) {
			return getRuleContext(CondContext.class,i);
		}
		public List<CondContext> cond() {
			return getRuleContexts(CondContext.class);
		}
		public OrContext(CondContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).enterOr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).exitOr(this);
		}
	}
	public static class CondOpContext extends CondContext {
		public OpContext op() {
			return getRuleContext(OpContext.class,0);
		}
		public CondOpContext(CondContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).enterCondOp(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).exitCondOp(this);
		}
	}
	public static class GroupContext extends CondContext {
		public CondContext cond() {
			return getRuleContext(CondContext.class,0);
		}
		public GroupContext(CondContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).enterGroup(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).exitGroup(this);
		}
	}
	public static class AndContext extends CondContext {
		public CondContext cond(int i) {
			return getRuleContext(CondContext.class,i);
		}
		public List<CondContext> cond() {
			return getRuleContexts(CondContext.class);
		}
		public AndContext(CondContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).enterAnd(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).exitAnd(this);
		}
	}

	public final CondContext cond() throws RecognitionException {
		return cond(0);
	}

	private CondContext cond(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		CondContext _localctx = new CondContext(_ctx, _parentState);
		CondContext _prevctx = _localctx;
		int _startState = 2;
		enterRecursionRule(_localctx, 2, RULE_cond, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(69);
			switch (_input.LA(1)) {
			case 2:
			case 10:
			case 15:
			case 16:
			case 18:
			case 22:
			case 23:
			case IDENTIFIER:
				{
				_localctx = new CondOpContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(42); op();
				}
				break;
			case 5:
				{
				_localctx = new GroupContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(43); match(5);
				setState(44); cond(0);
				setState(45); match(20);
				}
				break;
			case 12:
				{
				_localctx = new AndContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(47); match(12);
				setState(48); match(5);
				setState(49); cond(0);
				setState(52); 
				_errHandler.sync(this);
				_la = _input.LA(1);
				do {
					{
					{
					setState(50); match(3);
					setState(51); cond(0);
					}
					}
					setState(54); 
					_errHandler.sync(this);
					_la = _input.LA(1);
				} while ( _la==3 );
				setState(56); match(20);
				}
				break;
			case 4:
				{
				_localctx = new OrContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(58); match(4);
				setState(59); match(5);
				setState(60); cond(0);
				setState(63); 
				_errHandler.sync(this);
				_la = _input.LA(1);
				do {
					{
					{
					setState(61); match(3);
					setState(62); cond(0);
					}
					}
					setState(65); 
					_errHandler.sync(this);
					_la = _input.LA(1);
				} while ( _la==3 );
				setState(67); match(20);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(79);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,5,_ctx);
			while ( _alt!=2 && _alt!=-1 ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(77);
					switch ( getInterpreter().adaptivePredict(_input,4,_ctx) ) {
					case 1:
						{
						_localctx = new AndContext(new CondContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_cond);
						setState(71);
						if (!(precpred(_ctx, 3))) throw new FailedPredicateException(this, "precpred(_ctx, 3)");
						setState(72);
						_la = _input.LA(1);
						if ( !(_la==1 || _la==27) ) {
						_errHandler.recoverInline(this);
						}
						consume();
						setState(73); cond(4);
						}
						break;

					case 2:
						{
						_localctx = new OrContext(new CondContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_cond);
						setState(74);
						if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
						setState(75);
						_la = _input.LA(1);
						if ( !(_la==28 || _la==33) ) {
						_errHandler.recoverInline(this);
						}
						consume();
						setState(76); cond(2);
						}
						break;
					}
					} 
				}
				setState(81);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,5,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class OpContext extends ParserRuleContext {
		public LeContext le() {
			return getRuleContext(LeContext.class,0);
		}
		public NeContext ne() {
			return getRuleContext(NeContext.class,0);
		}
		public GtContext gt() {
			return getRuleContext(GtContext.class,0);
		}
		public InContext in() {
			return getRuleContext(InContext.class,0);
		}
		public GeContext ge() {
			return getRuleContext(GeContext.class,0);
		}
		public EqContext eq() {
			return getRuleContext(EqContext.class,0);
		}
		public LtContext lt() {
			return getRuleContext(LtContext.class,0);
		}
		public OpContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_op; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).enterOp(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).exitOp(this);
		}
	}

	public final OpContext op() throws RecognitionException {
		OpContext _localctx = new OpContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_op);
		try {
			setState(89);
			switch ( getInterpreter().adaptivePredict(_input,6,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(82); eq();
				}
				break;

			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(83); ne();
				}
				break;

			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(84); gt();
				}
				break;

			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(85); ge();
				}
				break;

			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(86); lt();
				}
				break;

			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(87); le();
				}
				break;

			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(88); in();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class EqContext extends ParserRuleContext {
		public TerminalNode VALUE() { return getToken(RqlParser.VALUE, 0); }
		public TerminalNode IDENTIFIER() { return getToken(RqlParser.IDENTIFIER, 0); }
		public EqContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_eq; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).enterEq(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).exitEq(this);
		}
	}

	public final EqContext eq() throws RecognitionException {
		EqContext _localctx = new EqContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_eq);
		try {
			setState(103);
			switch ( getInterpreter().adaptivePredict(_input,7,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(91); match(15);
				setState(92); match(5);
				setState(93); match(IDENTIFIER);
				setState(94); match(3);
				setState(95); match(VALUE);
				setState(96); match(20);
				}
				break;

			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(97); match(IDENTIFIER);
				setState(98); match(30);
				setState(99); match(VALUE);
				}
				break;

			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(100); match(IDENTIFIER);
				setState(101); match(24);
				setState(102); match(VALUE);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class NeContext extends ParserRuleContext {
		public TerminalNode VALUE() { return getToken(RqlParser.VALUE, 0); }
		public TerminalNode IDENTIFIER() { return getToken(RqlParser.IDENTIFIER, 0); }
		public NeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_ne; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).enterNe(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).exitNe(this);
		}
	}

	public final NeContext ne() throws RecognitionException {
		NeContext _localctx = new NeContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_ne);
		try {
			setState(114);
			switch (_input.LA(1)) {
			case 23:
				enterOuterAlt(_localctx, 1);
				{
				setState(105); match(23);
				setState(106); match(5);
				setState(107); match(IDENTIFIER);
				setState(108); match(3);
				setState(109); match(VALUE);
				setState(110); match(20);
				}
				break;
			case IDENTIFIER:
				enterOuterAlt(_localctx, 2);
				{
				setState(111); match(IDENTIFIER);
				setState(112); match(8);
				setState(113); match(VALUE);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class GtContext extends ParserRuleContext {
		public TerminalNode VALUE() { return getToken(RqlParser.VALUE, 0); }
		public TerminalNode IDENTIFIER() { return getToken(RqlParser.IDENTIFIER, 0); }
		public GtContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_gt; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).enterGt(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).exitGt(this);
		}
	}

	public final GtContext gt() throws RecognitionException {
		GtContext _localctx = new GtContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_gt);
		try {
			setState(128);
			switch ( getInterpreter().adaptivePredict(_input,9,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(116); match(22);
				setState(117); match(5);
				setState(118); match(IDENTIFIER);
				setState(119); match(3);
				setState(120); match(VALUE);
				setState(121); match(20);
				}
				break;

			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(122); match(IDENTIFIER);
				setState(123); match(6);
				setState(124); match(VALUE);
				}
				break;

			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(125); match(IDENTIFIER);
				setState(126); match(29);
				setState(127); match(VALUE);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class GeContext extends ParserRuleContext {
		public TerminalNode VALUE() { return getToken(RqlParser.VALUE, 0); }
		public TerminalNode IDENTIFIER() { return getToken(RqlParser.IDENTIFIER, 0); }
		public GeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_ge; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).enterGe(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).exitGe(this);
		}
	}

	public final GeContext ge() throws RecognitionException {
		GeContext _localctx = new GeContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_ge);
		try {
			setState(142);
			switch ( getInterpreter().adaptivePredict(_input,10,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(130); match(10);
				setState(131); match(5);
				setState(132); match(IDENTIFIER);
				setState(133); match(3);
				setState(134); match(VALUE);
				setState(135); match(20);
				}
				break;

			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(136); match(IDENTIFIER);
				setState(137); match(21);
				setState(138); match(VALUE);
				}
				break;

			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(139); match(IDENTIFIER);
				setState(140); match(32);
				setState(141); match(VALUE);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LtContext extends ParserRuleContext {
		public TerminalNode VALUE() { return getToken(RqlParser.VALUE, 0); }
		public TerminalNode IDENTIFIER() { return getToken(RqlParser.IDENTIFIER, 0); }
		public LtContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_lt; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).enterLt(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).exitLt(this);
		}
	}

	public final LtContext lt() throws RecognitionException {
		LtContext _localctx = new LtContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_lt);
		try {
			setState(156);
			switch ( getInterpreter().adaptivePredict(_input,11,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(144); match(16);
				setState(145); match(5);
				setState(146); match(IDENTIFIER);
				setState(147); match(3);
				setState(148); match(VALUE);
				setState(149); match(20);
				}
				break;

			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(150); match(IDENTIFIER);
				setState(151); match(31);
				setState(152); match(VALUE);
				}
				break;

			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(153); match(IDENTIFIER);
				setState(154); match(7);
				setState(155); match(VALUE);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LeContext extends ParserRuleContext {
		public TerminalNode VALUE() { return getToken(RqlParser.VALUE, 0); }
		public TerminalNode IDENTIFIER() { return getToken(RqlParser.IDENTIFIER, 0); }
		public LeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_le; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).enterLe(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).exitLe(this);
		}
	}

	public final LeContext le() throws RecognitionException {
		LeContext _localctx = new LeContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_le);
		try {
			setState(170);
			switch ( getInterpreter().adaptivePredict(_input,12,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(158); match(18);
				setState(159); match(5);
				setState(160); match(IDENTIFIER);
				setState(161); match(3);
				setState(162); match(VALUE);
				setState(163); match(20);
				}
				break;

			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(164); match(IDENTIFIER);
				setState(165); match(17);
				setState(166); match(VALUE);
				}
				break;

			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(167); match(IDENTIFIER);
				setState(168); match(9);
				setState(169); match(VALUE);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class InContext extends ParserRuleContext {
		public List<TerminalNode> VALUE() { return getTokens(RqlParser.VALUE); }
		public TerminalNode IDENTIFIER() { return getToken(RqlParser.IDENTIFIER, 0); }
		public TerminalNode VALUE(int i) {
			return getToken(RqlParser.VALUE, i);
		}
		public InContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_in; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).enterIn(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).exitIn(this);
		}
	}

	public final InContext in() throws RecognitionException {
		InContext _localctx = new InContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_in);
		int _la;
		try {
			int _alt;
			setState(202);
			switch ( getInterpreter().adaptivePredict(_input,16,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(172); match(2);
				setState(173); match(5);
				setState(174); match(IDENTIFIER);
				setState(175); match(3);
				setState(176); match(VALUE);
				setState(179); 
				_errHandler.sync(this);
				_la = _input.LA(1);
				do {
					{
					{
					setState(177); match(3);
					setState(178); match(VALUE);
					}
					}
					setState(181); 
					_errHandler.sync(this);
					_la = _input.LA(1);
				} while ( _la==3 );
				setState(183); match(20);
				}
				break;

			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(184); match(IDENTIFIER);
				setState(185); match(30);
				setState(186); match(VALUE);
				setState(189); 
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,14,_ctx);
				do {
					switch (_alt) {
					case 1:
						{
						{
						setState(187); match(3);
						setState(188); match(VALUE);
						}
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(191); 
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,14,_ctx);
				} while ( _alt!=2 && _alt!=-1 );
				}
				break;

			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(193); match(IDENTIFIER);
				setState(194); match(24);
				setState(195); match(VALUE);
				setState(198); 
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,15,_ctx);
				do {
					switch (_alt) {
					case 1:
						{
						{
						setState(196); match(3);
						setState(197); match(VALUE);
						}
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(200); 
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,15,_ctx);
				} while ( _alt!=2 && _alt!=-1 );
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class OrderContext extends ParserRuleContext {
		public List<TerminalNode> SIGN() { return getTokens(RqlParser.SIGN); }
		public TerminalNode IDENTIFIER(int i) {
			return getToken(RqlParser.IDENTIFIER, i);
		}
		public List<TerminalNode> IDENTIFIER() { return getTokens(RqlParser.IDENTIFIER); }
		public TerminalNode SIGN(int i) {
			return getToken(RqlParser.SIGN, i);
		}
		public OrderContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_order; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).enterOrder(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).exitOrder(this);
		}
	}

	public final OrderContext order() throws RecognitionException {
		OrderContext _localctx = new OrderContext(_ctx, getState());
		enterRule(_localctx, 20, RULE_order);
		int _la;
		try {
			int _alt;
			setState(266);
			switch ( getInterpreter().adaptivePredict(_input,29,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(204); match(13);
				setState(205); match(5);
				setState(207);
				_la = _input.LA(1);
				if (_la==SIGN) {
					{
					setState(206); match(SIGN);
					}
				}

				setState(209); match(IDENTIFIER);
				setState(217);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==3) {
					{
					{
					setState(210); match(3);
					setState(212);
					_la = _input.LA(1);
					if (_la==SIGN) {
						{
						setState(211); match(SIGN);
						}
					}

					setState(214); match(IDENTIFIER);
					}
					}
					setState(219);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(220); match(20);
				}
				break;

			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(221); match(13);
				setState(222); match(5);
				setState(223); match(IDENTIFIER);
				setState(225);
				_la = _input.LA(1);
				if (_la==SIGN) {
					{
					setState(224); match(SIGN);
					}
				}

				setState(234);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==3) {
					{
					{
					setState(227); match(3);
					setState(228); match(IDENTIFIER);
					setState(230);
					_la = _input.LA(1);
					if (_la==SIGN) {
						{
						setState(229); match(SIGN);
						}
					}

					}
					}
					setState(236);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(237); match(20);
				}
				break;

			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(239);
				_la = _input.LA(1);
				if (_la==SIGN) {
					{
					setState(238); match(SIGN);
					}
				}

				setState(241); match(IDENTIFIER);
				setState(249);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,25,_ctx);
				while ( _alt!=2 && _alt!=-1 ) {
					if ( _alt==1 ) {
						{
						{
						setState(242); match(3);
						setState(244);
						_la = _input.LA(1);
						if (_la==SIGN) {
							{
							setState(243); match(SIGN);
							}
						}

						setState(246); match(IDENTIFIER);
						}
						} 
					}
					setState(251);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,25,_ctx);
				}
				}
				break;

			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(252); match(IDENTIFIER);
				setState(254);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << 14) | (1L << 25) | (1L << SIGN))) != 0)) {
					{
					setState(253);
					_la = _input.LA(1);
					if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << 14) | (1L << 25) | (1L << SIGN))) != 0)) ) {
					_errHandler.recoverInline(this);
					}
					consume();
					}
				}

				setState(263);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,28,_ctx);
				while ( _alt!=2 && _alt!=-1 ) {
					if ( _alt==1 ) {
						{
						{
						setState(256); match(3);
						setState(257); match(IDENTIFIER);
						setState(259);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << 14) | (1L << 25) | (1L << SIGN))) != 0)) {
							{
							setState(258);
							_la = _input.LA(1);
							if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << 14) | (1L << 25) | (1L << SIGN))) != 0)) ) {
							_errHandler.recoverInline(this);
							}
							consume();
							}
						}

						}
						} 
					}
					setState(265);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,28,_ctx);
				}
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class RangeContext extends ParserRuleContext {
		public List<TerminalNode> VALUE() { return getTokens(RqlParser.VALUE); }
		public TerminalNode VALUE(int i) {
			return getToken(RqlParser.VALUE, i);
		}
		public RangeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_range; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).enterRange(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RqlListener ) ((RqlListener)listener).exitRange(this);
		}
	}

	public final RangeContext range() throws RecognitionException {
		RangeContext _localctx = new RangeContext(_ctx, getState());
		enterRule(_localctx, 22, RULE_range);
		try {
			setState(288);
			switch ( getInterpreter().adaptivePredict(_input,30,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(268); match(VALUE);
				}
				break;

			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(269); match(VALUE);
				setState(270); match(3);
				setState(271); match(VALUE);
				}
				break;

			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(272); match(19);
				setState(273); match(5);
				setState(274); match(VALUE);
				setState(275); match(20);
				}
				break;

			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(276); match(19);
				setState(277); match(5);
				setState(278); match(VALUE);
				setState(279); match(3);
				setState(280); match(VALUE);
				setState(281); match(20);
				}
				break;

			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(282); match(11);
				setState(283); match(5);
				setState(284); match(VALUE);
				setState(285); match(3);
				setState(286); match(VALUE);
				setState(287); match(20);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public boolean sempred(RuleContext _localctx, int ruleIndex, int predIndex) {
		switch (ruleIndex) {
		case 1: return cond_sempred((CondContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean cond_sempred(CondContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0: return precpred(_ctx, 3);

		case 1: return precpred(_ctx, 1);
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\u0430\ud6d1\u8206\uad2d\u4417\uaef1\u8d80\uaadd\3\'\u0125\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t"+
		"\13\4\f\t\f\4\r\t\r\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3"+
		"\2\3\2\3\2\5\2*\n\2\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\6\3\67"+
		"\n\3\r\3\16\38\3\3\3\3\3\3\3\3\3\3\3\3\3\3\6\3B\n\3\r\3\16\3C\3\3\3\3"+
		"\5\3H\n\3\3\3\3\3\3\3\3\3\3\3\3\3\7\3P\n\3\f\3\16\3S\13\3\3\4\3\4\3\4"+
		"\3\4\3\4\3\4\3\4\5\4\\\n\4\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5"+
		"\3\5\5\5j\n\5\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\5\6u\n\6\3\7\3\7\3\7"+
		"\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\5\7\u0083\n\7\3\b\3\b\3\b\3\b\3\b"+
		"\3\b\3\b\3\b\3\b\3\b\3\b\3\b\5\b\u0091\n\b\3\t\3\t\3\t\3\t\3\t\3\t\3\t"+
		"\3\t\3\t\3\t\3\t\3\t\5\t\u009f\n\t\3\n\3\n\3\n\3\n\3\n\3\n\3\n\3\n\3\n"+
		"\3\n\3\n\3\n\5\n\u00ad\n\n\3\13\3\13\3\13\3\13\3\13\3\13\3\13\6\13\u00b6"+
		"\n\13\r\13\16\13\u00b7\3\13\3\13\3\13\3\13\3\13\3\13\6\13\u00c0\n\13\r"+
		"\13\16\13\u00c1\3\13\3\13\3\13\3\13\3\13\6\13\u00c9\n\13\r\13\16\13\u00ca"+
		"\5\13\u00cd\n\13\3\f\3\f\3\f\5\f\u00d2\n\f\3\f\3\f\3\f\5\f\u00d7\n\f\3"+
		"\f\7\f\u00da\n\f\f\f\16\f\u00dd\13\f\3\f\3\f\3\f\3\f\3\f\5\f\u00e4\n\f"+
		"\3\f\3\f\3\f\5\f\u00e9\n\f\7\f\u00eb\n\f\f\f\16\f\u00ee\13\f\3\f\3\f\5"+
		"\f\u00f2\n\f\3\f\3\f\3\f\5\f\u00f7\n\f\3\f\7\f\u00fa\n\f\f\f\16\f\u00fd"+
		"\13\f\3\f\3\f\5\f\u0101\n\f\3\f\3\f\3\f\5\f\u0106\n\f\7\f\u0108\n\f\f"+
		"\f\16\f\u010b\13\f\5\f\u010d\n\f\3\r\3\r\3\r\3\r\3\r\3\r\3\r\3\r\3\r\3"+
		"\r\3\r\3\r\3\r\3\r\3\r\3\r\3\r\3\r\3\r\3\r\5\r\u0123\n\r\3\r\2\3\4\16"+
		"\2\4\6\b\n\f\16\20\22\24\26\30\2\6\4\2\5\5\34\34\4\2\3\3\35\35\4\2\36"+
		"\36##\5\2\20\20\33\33&&\u014b\2)\3\2\2\2\4G\3\2\2\2\6[\3\2\2\2\bi\3\2"+
		"\2\2\nt\3\2\2\2\f\u0082\3\2\2\2\16\u0090\3\2\2\2\20\u009e\3\2\2\2\22\u00ac"+
		"\3\2\2\2\24\u00cc\3\2\2\2\26\u010c\3\2\2\2\30\u0122\3\2\2\2\32*\5\4\3"+
		"\2\33\34\5\4\3\2\34\35\t\2\2\2\35\36\5\26\f\2\36*\3\2\2\2\37 \5\4\3\2"+
		" !\t\2\2\2!\"\5\30\r\2\"*\3\2\2\2#$\5\4\3\2$%\t\2\2\2%&\5\26\f\2&\'\t"+
		"\2\2\2\'(\5\30\r\2(*\3\2\2\2)\32\3\2\2\2)\33\3\2\2\2)\37\3\2\2\2)#\3\2"+
		"\2\2*\3\3\2\2\2+,\b\3\1\2,H\5\6\4\2-.\7\7\2\2./\5\4\3\2/\60\7\26\2\2\60"+
		"H\3\2\2\2\61\62\7\16\2\2\62\63\7\7\2\2\63\66\5\4\3\2\64\65\7\5\2\2\65"+
		"\67\5\4\3\2\66\64\3\2\2\2\678\3\2\2\28\66\3\2\2\289\3\2\2\29:\3\2\2\2"+
		":;\7\26\2\2;H\3\2\2\2<=\7\6\2\2=>\7\7\2\2>A\5\4\3\2?@\7\5\2\2@B\5\4\3"+
		"\2A?\3\2\2\2BC\3\2\2\2CA\3\2\2\2CD\3\2\2\2DE\3\2\2\2EF\7\26\2\2FH\3\2"+
		"\2\2G+\3\2\2\2G-\3\2\2\2G\61\3\2\2\2G<\3\2\2\2HQ\3\2\2\2IJ\f\5\2\2JK\t"+
		"\3\2\2KP\5\4\3\6LM\f\3\2\2MN\t\4\2\2NP\5\4\3\4OI\3\2\2\2OL\3\2\2\2PS\3"+
		"\2\2\2QO\3\2\2\2QR\3\2\2\2R\5\3\2\2\2SQ\3\2\2\2T\\\5\b\5\2U\\\5\n\6\2"+
		"V\\\5\f\7\2W\\\5\16\b\2X\\\5\20\t\2Y\\\5\22\n\2Z\\\5\24\13\2[T\3\2\2\2"+
		"[U\3\2\2\2[V\3\2\2\2[W\3\2\2\2[X\3\2\2\2[Y\3\2\2\2[Z\3\2\2\2\\\7\3\2\2"+
		"\2]^\7\21\2\2^_\7\7\2\2_`\7$\2\2`a\7\5\2\2ab\7%\2\2bj\7\26\2\2cd\7$\2"+
		"\2de\7 \2\2ej\7%\2\2fg\7$\2\2gh\7\32\2\2hj\7%\2\2i]\3\2\2\2ic\3\2\2\2"+
		"if\3\2\2\2j\t\3\2\2\2kl\7\31\2\2lm\7\7\2\2mn\7$\2\2no\7\5\2\2op\7%\2\2"+
		"pu\7\26\2\2qr\7$\2\2rs\7\n\2\2su\7%\2\2tk\3\2\2\2tq\3\2\2\2u\13\3\2\2"+
		"\2vw\7\30\2\2wx\7\7\2\2xy\7$\2\2yz\7\5\2\2z{\7%\2\2{\u0083\7\26\2\2|}"+
		"\7$\2\2}~\7\b\2\2~\u0083\7%\2\2\177\u0080\7$\2\2\u0080\u0081\7\37\2\2"+
		"\u0081\u0083\7%\2\2\u0082v\3\2\2\2\u0082|\3\2\2\2\u0082\177\3\2\2\2\u0083"+
		"\r\3\2\2\2\u0084\u0085\7\f\2\2\u0085\u0086\7\7\2\2\u0086\u0087\7$\2\2"+
		"\u0087\u0088\7\5\2\2\u0088\u0089\7%\2\2\u0089\u0091\7\26\2\2\u008a\u008b"+
		"\7$\2\2\u008b\u008c\7\27\2\2\u008c\u0091\7%\2\2\u008d\u008e\7$\2\2\u008e"+
		"\u008f\7\"\2\2\u008f\u0091\7%\2\2\u0090\u0084\3\2\2\2\u0090\u008a\3\2"+
		"\2\2\u0090\u008d\3\2\2\2\u0091\17\3\2\2\2\u0092\u0093\7\22\2\2\u0093\u0094"+
		"\7\7\2\2\u0094\u0095\7$\2\2\u0095\u0096\7\5\2\2\u0096\u0097\7%\2\2\u0097"+
		"\u009f\7\26\2\2\u0098\u0099\7$\2\2\u0099\u009a\7!\2\2\u009a\u009f\7%\2"+
		"\2\u009b\u009c\7$\2\2\u009c\u009d\7\t\2\2\u009d\u009f\7%\2\2\u009e\u0092"+
		"\3\2\2\2\u009e\u0098\3\2\2\2\u009e\u009b\3\2\2\2\u009f\21\3\2\2\2\u00a0"+
		"\u00a1\7\24\2\2\u00a1\u00a2\7\7\2\2\u00a2\u00a3\7$\2\2\u00a3\u00a4\7\5"+
		"\2\2\u00a4\u00a5\7%\2\2\u00a5\u00ad\7\26\2\2\u00a6\u00a7\7$\2\2\u00a7"+
		"\u00a8\7\23\2\2\u00a8\u00ad\7%\2\2\u00a9\u00aa\7$\2\2\u00aa\u00ab\7\13"+
		"\2\2\u00ab\u00ad\7%\2\2\u00ac\u00a0\3\2\2\2\u00ac\u00a6\3\2\2\2\u00ac"+
		"\u00a9\3\2\2\2\u00ad\23\3\2\2\2\u00ae\u00af\7\4\2\2\u00af\u00b0\7\7\2"+
		"\2\u00b0\u00b1\7$\2\2\u00b1\u00b2\7\5\2\2\u00b2\u00b5\7%\2\2\u00b3\u00b4"+
		"\7\5\2\2\u00b4\u00b6\7%\2\2\u00b5\u00b3\3\2\2\2\u00b6\u00b7\3\2\2\2\u00b7"+
		"\u00b5\3\2\2\2\u00b7\u00b8\3\2\2\2\u00b8\u00b9\3\2\2\2\u00b9\u00cd\7\26"+
		"\2\2\u00ba\u00bb\7$\2\2\u00bb\u00bc\7 \2\2\u00bc\u00bf\7%\2\2\u00bd\u00be"+
		"\7\5\2\2\u00be\u00c0\7%\2\2\u00bf\u00bd\3\2\2\2\u00c0\u00c1\3\2\2\2\u00c1"+
		"\u00bf\3\2\2\2\u00c1\u00c2\3\2\2\2\u00c2\u00cd\3\2\2\2\u00c3\u00c4\7$"+
		"\2\2\u00c4\u00c5\7\32\2\2\u00c5\u00c8\7%\2\2\u00c6\u00c7\7\5\2\2\u00c7"+
		"\u00c9\7%\2\2\u00c8\u00c6\3\2\2\2\u00c9\u00ca\3\2\2\2\u00ca\u00c8\3\2"+
		"\2\2\u00ca\u00cb\3\2\2\2\u00cb\u00cd\3\2\2\2\u00cc\u00ae\3\2\2\2\u00cc"+
		"\u00ba\3\2\2\2\u00cc\u00c3\3\2\2\2\u00cd\25\3\2\2\2\u00ce\u00cf\7\17\2"+
		"\2\u00cf\u00d1\7\7\2\2\u00d0\u00d2\7&\2\2\u00d1\u00d0\3\2\2\2\u00d1\u00d2"+
		"\3\2\2\2\u00d2\u00d3\3\2\2\2\u00d3\u00db\7$\2\2\u00d4\u00d6\7\5\2\2\u00d5"+
		"\u00d7\7&\2\2\u00d6\u00d5\3\2\2\2\u00d6\u00d7\3\2\2\2\u00d7\u00d8\3\2"+
		"\2\2\u00d8\u00da\7$\2\2\u00d9\u00d4\3\2\2\2\u00da\u00dd\3\2\2\2\u00db"+
		"\u00d9\3\2\2\2\u00db\u00dc\3\2\2\2\u00dc\u00de\3\2\2\2\u00dd\u00db\3\2"+
		"\2\2\u00de\u010d\7\26\2\2\u00df\u00e0\7\17\2\2\u00e0\u00e1\7\7\2\2\u00e1"+
		"\u00e3\7$\2\2\u00e2\u00e4\7&\2\2\u00e3\u00e2\3\2\2\2\u00e3\u00e4\3\2\2"+
		"\2\u00e4\u00ec\3\2\2\2\u00e5\u00e6\7\5\2\2\u00e6\u00e8\7$\2\2\u00e7\u00e9"+
		"\7&\2\2\u00e8\u00e7\3\2\2\2\u00e8\u00e9\3\2\2\2\u00e9\u00eb\3\2\2\2\u00ea"+
		"\u00e5\3\2\2\2\u00eb\u00ee\3\2\2\2\u00ec\u00ea\3\2\2\2\u00ec\u00ed\3\2"+
		"\2\2\u00ed\u00ef\3\2\2\2\u00ee\u00ec\3\2\2\2\u00ef\u010d\7\26\2\2\u00f0"+
		"\u00f2\7&\2\2\u00f1\u00f0\3\2\2\2\u00f1\u00f2\3\2\2\2\u00f2\u00f3\3\2"+
		"\2\2\u00f3\u00fb\7$\2\2\u00f4\u00f6\7\5\2\2\u00f5\u00f7\7&\2\2\u00f6\u00f5"+
		"\3\2\2\2\u00f6\u00f7\3\2\2\2\u00f7\u00f8\3\2\2\2\u00f8\u00fa\7$\2\2\u00f9"+
		"\u00f4\3\2\2\2\u00fa\u00fd\3\2\2\2\u00fb\u00f9\3\2\2\2\u00fb\u00fc\3\2"+
		"\2\2\u00fc\u010d\3\2\2\2\u00fd\u00fb\3\2\2\2\u00fe\u0100\7$\2\2\u00ff"+
		"\u0101\t\5\2\2\u0100\u00ff\3\2\2\2\u0100\u0101\3\2\2\2\u0101\u0109\3\2"+
		"\2\2\u0102\u0103\7\5\2\2\u0103\u0105\7$\2\2\u0104\u0106\t\5\2\2\u0105"+
		"\u0104\3\2\2\2\u0105\u0106\3\2\2\2\u0106\u0108\3\2\2\2\u0107\u0102\3\2"+
		"\2\2\u0108\u010b\3\2\2\2\u0109\u0107\3\2\2\2\u0109\u010a\3\2\2\2\u010a"+
		"\u010d\3\2\2\2\u010b\u0109\3\2\2\2\u010c\u00ce\3\2\2\2\u010c\u00df\3\2"+
		"\2\2\u010c\u00f1\3\2\2\2\u010c\u00fe\3\2\2\2\u010d\27\3\2\2\2\u010e\u0123"+
		"\7%\2\2\u010f\u0110\7%\2\2\u0110\u0111\7\5\2\2\u0111\u0123\7%\2\2\u0112"+
		"\u0113\7\25\2\2\u0113\u0114\7\7\2\2\u0114\u0115\7%\2\2\u0115\u0123\7\26"+
		"\2\2\u0116\u0117\7\25\2\2\u0117\u0118\7\7\2\2\u0118\u0119\7%\2\2\u0119"+
		"\u011a\7\5\2\2\u011a\u011b\7%\2\2\u011b\u0123\7\26\2\2\u011c\u011d\7\r"+
		"\2\2\u011d\u011e\7\7\2\2\u011e\u011f\7%\2\2\u011f\u0120\7\5\2\2\u0120"+
		"\u0121\7%\2\2\u0121\u0123\7\26\2\2\u0122\u010e\3\2\2\2\u0122\u010f\3\2"+
		"\2\2\u0122\u0112\3\2\2\2\u0122\u0116\3\2\2\2\u0122\u011c\3\2\2\2\u0123"+
		"\31\3\2\2\2!)8CGOQ[it\u0082\u0090\u009e\u00ac\u00b7\u00c1\u00ca\u00cc"+
		"\u00d1\u00d6\u00db\u00e3\u00e8\u00ec\u00f1\u00f6\u00fb\u0100\u0105\u0109"+
		"\u010c\u0122";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}