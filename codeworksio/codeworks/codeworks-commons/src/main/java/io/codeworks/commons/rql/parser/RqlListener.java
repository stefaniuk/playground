// Generated from Rql.g4 by ANTLR 4.2
package io.codeworks.commons.rql.parser;
import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link RqlParser}.
 */
public interface RqlListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link RqlParser#range}.
	 * @param ctx the parse tree
	 */
	void enterRange(@NotNull RqlParser.RangeContext ctx);
	/**
	 * Exit a parse tree produced by {@link RqlParser#range}.
	 * @param ctx the parse tree
	 */
	void exitRange(@NotNull RqlParser.RangeContext ctx);

	/**
	 * Enter a parse tree produced by {@link RqlParser#op}.
	 * @param ctx the parse tree
	 */
	void enterOp(@NotNull RqlParser.OpContext ctx);
	/**
	 * Exit a parse tree produced by {@link RqlParser#op}.
	 * @param ctx the parse tree
	 */
	void exitOp(@NotNull RqlParser.OpContext ctx);

	/**
	 * Enter a parse tree produced by {@link RqlParser#query}.
	 * @param ctx the parse tree
	 */
	void enterQuery(@NotNull RqlParser.QueryContext ctx);
	/**
	 * Exit a parse tree produced by {@link RqlParser#query}.
	 * @param ctx the parse tree
	 */
	void exitQuery(@NotNull RqlParser.QueryContext ctx);

	/**
	 * Enter a parse tree produced by {@link RqlParser#ge}.
	 * @param ctx the parse tree
	 */
	void enterGe(@NotNull RqlParser.GeContext ctx);
	/**
	 * Exit a parse tree produced by {@link RqlParser#ge}.
	 * @param ctx the parse tree
	 */
	void exitGe(@NotNull RqlParser.GeContext ctx);

	/**
	 * Enter a parse tree produced by {@link RqlParser#lt}.
	 * @param ctx the parse tree
	 */
	void enterLt(@NotNull RqlParser.LtContext ctx);
	/**
	 * Exit a parse tree produced by {@link RqlParser#lt}.
	 * @param ctx the parse tree
	 */
	void exitLt(@NotNull RqlParser.LtContext ctx);

	/**
	 * Enter a parse tree produced by {@link RqlParser#in}.
	 * @param ctx the parse tree
	 */
	void enterIn(@NotNull RqlParser.InContext ctx);
	/**
	 * Exit a parse tree produced by {@link RqlParser#in}.
	 * @param ctx the parse tree
	 */
	void exitIn(@NotNull RqlParser.InContext ctx);

	/**
	 * Enter a parse tree produced by {@link RqlParser#CondOp}.
	 * @param ctx the parse tree
	 */
	void enterCondOp(@NotNull RqlParser.CondOpContext ctx);
	/**
	 * Exit a parse tree produced by {@link RqlParser#CondOp}.
	 * @param ctx the parse tree
	 */
	void exitCondOp(@NotNull RqlParser.CondOpContext ctx);

	/**
	 * Enter a parse tree produced by {@link RqlParser#Group}.
	 * @param ctx the parse tree
	 */
	void enterGroup(@NotNull RqlParser.GroupContext ctx);
	/**
	 * Exit a parse tree produced by {@link RqlParser#Group}.
	 * @param ctx the parse tree
	 */
	void exitGroup(@NotNull RqlParser.GroupContext ctx);

	/**
	 * Enter a parse tree produced by {@link RqlParser#order}.
	 * @param ctx the parse tree
	 */
	void enterOrder(@NotNull RqlParser.OrderContext ctx);
	/**
	 * Exit a parse tree produced by {@link RqlParser#order}.
	 * @param ctx the parse tree
	 */
	void exitOrder(@NotNull RqlParser.OrderContext ctx);

	/**
	 * Enter a parse tree produced by {@link RqlParser#le}.
	 * @param ctx the parse tree
	 */
	void enterLe(@NotNull RqlParser.LeContext ctx);
	/**
	 * Exit a parse tree produced by {@link RqlParser#le}.
	 * @param ctx the parse tree
	 */
	void exitLe(@NotNull RqlParser.LeContext ctx);

	/**
	 * Enter a parse tree produced by {@link RqlParser#Or}.
	 * @param ctx the parse tree
	 */
	void enterOr(@NotNull RqlParser.OrContext ctx);
	/**
	 * Exit a parse tree produced by {@link RqlParser#Or}.
	 * @param ctx the parse tree
	 */
	void exitOr(@NotNull RqlParser.OrContext ctx);

	/**
	 * Enter a parse tree produced by {@link RqlParser#ne}.
	 * @param ctx the parse tree
	 */
	void enterNe(@NotNull RqlParser.NeContext ctx);
	/**
	 * Exit a parse tree produced by {@link RqlParser#ne}.
	 * @param ctx the parse tree
	 */
	void exitNe(@NotNull RqlParser.NeContext ctx);

	/**
	 * Enter a parse tree produced by {@link RqlParser#gt}.
	 * @param ctx the parse tree
	 */
	void enterGt(@NotNull RqlParser.GtContext ctx);
	/**
	 * Exit a parse tree produced by {@link RqlParser#gt}.
	 * @param ctx the parse tree
	 */
	void exitGt(@NotNull RqlParser.GtContext ctx);

	/**
	 * Enter a parse tree produced by {@link RqlParser#And}.
	 * @param ctx the parse tree
	 */
	void enterAnd(@NotNull RqlParser.AndContext ctx);
	/**
	 * Exit a parse tree produced by {@link RqlParser#And}.
	 * @param ctx the parse tree
	 */
	void exitAnd(@NotNull RqlParser.AndContext ctx);

	/**
	 * Enter a parse tree produced by {@link RqlParser#eq}.
	 * @param ctx the parse tree
	 */
	void enterEq(@NotNull RqlParser.EqContext ctx);
	/**
	 * Exit a parse tree produced by {@link RqlParser#eq}.
	 * @param ctx the parse tree
	 */
	void exitEq(@NotNull RqlParser.EqContext ctx);
}